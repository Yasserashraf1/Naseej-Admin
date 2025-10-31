import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants/colors.dart';

class ImageUploadWidget extends StatefulWidget {
  final List<File> images;
  final List<String>? existingImages;
  final Function(List<File>) onImagesSelected;
  final Function(int) onImageRemoved;
  final Function(int)? onExistingImageRemoved;
  final int maxImages;
  final bool singleImage;
  final String? title;
  final String? description;

  const ImageUploadWidget({
    Key? key,
    required this.images,
    this.existingImages,
    required this.onImagesSelected,
    required this.onImageRemoved,
    this.onExistingImageRemoved,
    this.maxImages = 5,
    this.singleImage = false,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final totalImages = widget.images.length + (widget.existingImages?.length ?? 0);
    final canAddMore = totalImages < widget.maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          SizedBox(height: 4),
        ],
        if (widget.description != null) ...[
          Text(
            widget.description!,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 8),
        ],

        // Images Grid
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGray),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Existing Images
                if (widget.existingImages != null && widget.existingImages!.isNotEmpty) ...[
                  _buildExistingImagesSection(),
                  if (widget.images.isNotEmpty || canAddMore) Divider(),
                ],

                // New Images
                if (widget.images.isNotEmpty) ...[
                  _buildNewImagesSection(),
                  if (canAddMore) Divider(),
                ],

                // Add Image Button
                if (canAddMore) _buildAddButton(),
              ],
            ),
          ),
        ),

        // Helper Text
        if (totalImages == 0) ...[
          SizedBox(height: 8),
          Text(
            'No images selected',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray,
              fontStyle: FontStyle.italic,
            ),
          ),
        ] else if (!canAddMore) ...[
          SizedBox(height: 8),
          Text(
            'Maximum ${widget.maxImages} images allowed',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.warning,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExistingImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Images',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.gray,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.existingImages!.asMap().entries.map((entry) {
            final index = entry.key;
            final imageUrl = entry.value;
            return _buildExistingImageItem(imageUrl, index);
          }).toList(),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildExistingImageItem(String imageUrl, int index) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: AppColors.lightGray),
          ),
        ),
        if (widget.onExistingImageRemoved != null)
          Positioned(
            top: -4,
            right: -4,
            child: GestureDetector(
              onTap: () => widget.onExistingImageRemoved!(index),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNewImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Images',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.gray,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.images.asMap().entries.map((entry) {
            final index = entry.key;
            final imageFile = entry.value;
            return _buildNewImageItem(imageFile, index);
          }).toList(),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildNewImageItem(File imageFile, int index) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(imageFile),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: AppColors.lightGray),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => widget.onImageRemoved(index),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _pickImages,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.lightGray,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                Icons.cloud_upload,
                size: 32,
                color: AppColors.gray,
              ),
              SizedBox(height: 8),
              Text(
                widget.singleImage ? 'Tap to upload image' : 'Tap to upload images',
                style: TextStyle(
                  color: AppColors.gray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.singleImage
                    ? 'JPG, PNG, WEBP (Max 5MB)'
                    : 'Up to ${widget.maxImages} images • JPG, PNG, WEBP',
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    if (widget.singleImage) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image != null) {
        widget.onImagesSelected([File(image.path)]);
      }
    } else {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (images.isNotEmpty) {
        final files = images.map((image) => File(image.path)).toList();
        // Limit to max images
        final remainingSlots = widget.maxImages - widget.images.length;
        if (files.length > remainingSlots) {
          widget.onImagesSelected(files.sublist(0, remainingSlots));
        } else {
          widget.onImagesSelected(files);
        }
      }
    }
  }
}

// Single Image Upload Variant
class SingleImageUpload extends StatelessWidget {
  final File? image;
  final String? existingImageUrl;
  final Function(File) onImageSelected;
  final Function() onImageRemoved;
  final Function()? onExistingImageRemoved;
  final String title;
  final String description;
  final double size;

  const SingleImageUpload({
    Key? key,
    this.image,
    this.existingImageUrl,
    required this.onImageSelected,
    required this.onImageRemoved,
    this.onExistingImageRemoved,
    this.title = 'Image',
    this.description = 'Upload a single image',
    this.size = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasImage = image != null || existingImageUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray,
          ),
        ),
        SizedBox(height: 12),

        // Image Preview or Upload Area
        if (hasImage) _buildImagePreview() else _buildUploadArea(),

        // Action Buttons
        if (hasImage) ...[
          SizedBox(height: 8),
          Row(
            children: [
              _buildActionButton(
                text: 'Change Image',
                icon: Icons.edit,
                onPressed: _pickImage,
              ),
              SizedBox(width: 8),
              _buildActionButton(
                text: 'Remove',
                icon: Icons.delete,
                onPressed: image != null
                    ? onImageRemoved
                    : onExistingImageRemoved ?? () {},
                isDanger: true,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: image != null
              ? FileImage(image!)
              : NetworkImage(existingImageUrl!) as ImageProvider,
          fit: BoxFit.cover,
        ),
        border: Border.all(color: AppColors.lightGray),
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.lightGray,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 32,
              color: AppColors.gray,
            ),
            SizedBox(height: 8),
            Text(
              'Add Image',
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    bool isDanger = false,
  }) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: isDanger ? AppColors.error.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 16,
            color: isDanger ? AppColors.error : AppColors.primary,
          ),
          label: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDanger ? AppColors.error : AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (image != null) {
      onImageSelected(File(image.path));
    }
  }
}