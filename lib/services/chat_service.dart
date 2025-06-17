import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../models/api_config.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ApiConfig? _apiConfig;

  // Get API configuration from Firebase
  Future<ApiConfig> _getApiConfig() async {
    if (_apiConfig != null) return _apiConfig!;

    try {
      final doc = await _firestore.collection('config').doc('api').get();
      if (!doc.exists) {
        throw Exception('API configuration not found');
      }

      _apiConfig = ApiConfig.fromMap(doc.data()!);
      return _apiConfig!;
    } catch (e) {
      throw Exception('Failed to load API configuration: $e');
    }
  }

  // Get all conversations
  Stream<List<Conversation>> getConversations() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Conversation.fromFirestore(doc))
          .toList();
    });
  }

  // Get messages for a specific conversation
  Stream<List<ChatMessage>> getMessagesForConversation(String conversationId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    });
  }

  // Create a new conversation
  Future<String> createNewConversation() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Fetch API config when starting a new conversation
    await _getApiConfig();

    final conversation = Conversation(
      id: '',
      title: 'AI Chat ${DateTime.now().toString()}',
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
      messages: [],
    );

    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .add(conversation.toMap());

    return docRef.id;
  }

  // Send message to a conversation
  Future<void> sendMessage(
      String conversationId, String text, bool isUser) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final message = ChatMessage(
      id: '',
      sender: isUser ? 'user' : 'AI',
      text: text,
      timestamp: DateTime.now(),
      isUser: isUser,
    );

    // Add message to conversation
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(message.toMap());

    // Update conversation's lastMessageAt
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .update({
      'lastMessageAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Call your custom API
  Future<String> getAIResponse(String userMessage) async {
    try {
      // Get fresh API config for each request
      final apiConfig = await _getApiConfig();

      final response = await http.post(
        Uri.parse(apiConfig.fullEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "Explain how AI works in a few words"}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null) {
          return data['candidates'][0]['content']['parts'][0]['text'] ??
              'Sorry, I could not process your request.';
        } else {
          return 'Error: API request was not successful';
        }
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    // Delete all messages in the conversation
    final messages = await _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .get();

    final batch = _firestore.batch();
    for (var doc in messages.docs) {
      batch.delete(doc.reference);
    }

    // Delete the conversation document
    batch.delete(_firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId));

    await batch.commit();
  }
}
