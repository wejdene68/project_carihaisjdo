import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/chat_service.dart';
import '../../models/chat_message.dart';
import '../../models/conversation.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  bool _isTyping = false;
  String? _currentConversationId;
  bool _isViewingHistory = false;

  void _startNewConversation() async {
    setState(() {
      _currentConversationId = null;
      _isViewingHistory = false;
    });
  }

  void _viewConversation(String conversationId) {
    setState(() {
      _currentConversationId = conversationId;
      _isViewingHistory = true;
    });
    // Scroll to bottom when viewing old conversation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _continueCurrentChat() {
    setState(() {
      _isViewingHistory = false;
    });
  }

  void _sendMessage() async {
    if (_isViewingHistory) {
      // If viewing history, start a new conversation with the same context
      _currentConversationId = await _chatService.createNewConversation();
      setState(() {
        _isViewingHistory = false;
      });
    }

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _controller.clear();
      _isTyping = true;
    });

    // Create new conversation if none exists
    if (_currentConversationId == null) {
      _currentConversationId = await _chatService.createNewConversation();
    }

    // Send user message
    await _chatService.sendMessage(_currentConversationId!, text, true);

    // Get AI response
    final response = await _chatService.getAIResponse(text);

    // Send AI response
    await _chatService.sendMessage(_currentConversationId!, response, false);

    setState(() {
      _isTyping = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(ChatMessage message) {
    final formattedTime = DateFormat('h:mm a').format(message.timestamp);

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color:
                  message.isUser ? Colors.blue[300] : const Color(0xFFEAEAEA),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(message.isUser ? 18 : 0),
                bottomRight: Radius.circular(message.isUser ? 0 : 18),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 15.5,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14.0, left: 14.0),
            child: Text(
              formattedTime,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'AI is typing...',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildConversationList() {
    return StreamBuilder<List<Conversation>>(
      stream: _chatService.getConversations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final conversations = snapshot.data!;

        if (conversations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No conversations yet',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _startNewConversation,
                  child: const Text('Start New Conversation'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: conversations.length + 1, // +1 for the "New Chat" button
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: _startNewConversation,
                  icon: const Icon(Icons.add),
                  label: const Text('New Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    foregroundColor: Colors.white,
                  ),
                ),
              );
            }

            final conversation = conversations[index - 1];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[300],
                child: const Icon(Icons.chat, color: Colors.white),
              ),
              title: Text(conversation.title),
              subtitle: Text(
                DateFormat('MMM d, y • h:mm a')
                    .format(conversation.lastMessageAt),
                style: TextStyle(color: Colors.grey[600]),
              ),
              onTap: () => _viewConversation(conversation.id),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    _chatService.deleteConversation(conversation.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChatView() {
    if (_currentConversationId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start a new conversation',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _startNewConversation,
              icon: const Icon(Icons.add),
              label: const Text('New Chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        StreamBuilder<List<ChatMessage>>(
          stream:
              _chatService.getMessagesForConversation(_currentConversationId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final messages = snapshot.data!;

            if (messages.isEmpty) {
              return Center(
                child: Text(
                  'No messages in this conversation',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemCount:
                  messages.length + (_isTyping && !_isViewingHistory ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping &&
                    !_isViewingHistory &&
                    index == messages.length) {
                  return _buildTypingIndicator();
                } else {
                  return _buildMessage(messages[index]);
                }
              },
            );
          },
        ),
        if (_isViewingHistory)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'This is a past conversation',
                      style: TextStyle(color: Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _continueCurrentChat,
                      icon: const Icon(Icons.chat),
                      label: const Text('Continue Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/end3.webp',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.white.withValues(alpha: 0.5),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.blue[300]?.withValues(alpha: 0.9),
                  title: Text(
                    _isViewingHistory ? 'Chat History' : 'Chat AI',
                    style: const TextStyle(color: Colors.white),
                  ),
                  leading: _isViewingHistory
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _startNewConversation,
                        )
                      : null,
                  actions: [
                    if (!_isViewingHistory)
                      IconButton(
                        icon: const Icon(Icons.history),
                        onPressed: () {
                          setState(() {
                            _currentConversationId = null;
                            _isViewingHistory = true;
                          });
                        },
                      ),
                  ],
                  elevation: 0,
                ),
                Expanded(
                  child: _isViewingHistory && _currentConversationId == null
                      ? _buildConversationList()
                      : _buildChatView(),
                ),
                if (!_isViewingHistory)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0)
                                    .withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText: "Send a message...",
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _sendMessage,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue[300],
                              radius: 22,
                              child: const Icon(Icons.send,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
