import os
from PIL import Image
from pathlib import Path
import concurrent.futures

def compress_image(input_path, output_path, quality=80):
    """Compress an image and save as WebP"""
    try:
        with Image.open(input_path) as img:
            # Create parent directories if they don't exist
            os.makedirs(os.path.dirname(output_path), exist_ok=True)
            
            # Convert to WebP with specified quality
            output_path = f"{os.path.splitext(output_path)[0]}.webp"
            img.save(output_path, 'WEBP', quality=quality, method=6)
            
            # Calculate savings
            original_size = os.path.getsize(input_path)
            new_size = os.path.getsize(output_path)
            savings = (original_size - new_size) / original_size * 100
            
            print(f"Compressed: {input_path} → {output_path}")
            print(f"Reduced from {original_size/1024:.1f}KB to {new_size/1024:.1f}KB (-{savings:.1f}%)")
            
            return True
    except Exception as e:
        print(f"Error processing {input_path}: {str(e)}")
        return False

def process_directory(input_dir, output_dir, quality=80):
    """Process all images in a directory"""
    supported_formats = ('.png', '.jpg', '.jpeg', '.bmp', '.tiff')
    processed_files = 0
    
    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = []
        
        for root, _, files in os.walk(input_dir):
            for file in files:
                if file.lower().endswith(supported_formats):
                    input_path = os.path.join(root, file)
                    relative_path = os.path.relpath(input_path, input_dir)
                    output_path = os.path.join(output_dir, relative_path)
                    futures.append(executor.submit(compress_image, input_path, output_path, quality))
        
        for future in concurrent.futures.as_completed(futures):
            if future.result():
                processed_files += 1
    
    print(f"\nProcessing complete! {processed_files} images were optimized.")

if __name__ == "__main__":
    # Configuration
    INPUT_DIR = "image"  # Your original images
    OUTPUT_DIR = "img"  # Where to save optimized images
    QUALITY = 80  # Quality setting (1-100)
    
    # Check if input directory exists
    if not os.path.exists(INPUT_DIR):
        print(f"Error: Input directory '{INPUT_DIR}' does not exist!")
        exit(1)
    
    print(f"Starting image optimization...")
    print(f"Source: {INPUT_DIR}")
    print(f"Destination: {OUTPUT_DIR}")
    print(f"Quality: {QUALITY}\n")
    
    process_directory(INPUT_DIR, OUTPUT_DIR, QUALITY)