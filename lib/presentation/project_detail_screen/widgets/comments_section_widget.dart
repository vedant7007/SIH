import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommentsSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final Function(String) onAddComment;

  const CommentsSectionWidget({
    Key? key,
    required this.comments,
    required this.onAddComment,
  }) : super(key: key);

  @override
  State<CommentsSectionWidget> createState() => _CommentsSectionWidgetState();
}

class _CommentsSectionWidgetState extends State<CommentsSectionWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.trim().isNotEmpty) {
      widget.onAddComment(_commentController.text.trim());
      _commentController.clear();
      _commentFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Comments & Discussion',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            if (widget.comments.isNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      _isExpanded
                          ? 'Collapse'
                          : 'View All (${widget.comments.length})',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: _isExpanded
                          ? 'keyboard_arrow_up'
                          : 'keyboard_arrow_down',
                      size: 16,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 2.h),

        // Add Comment Section
        _buildAddCommentSection(),

        if (widget.comments.isNotEmpty) ...[
          SizedBox(height: 3.h),
          // Comments List
          _buildCommentsList(),
        ] else ...[
          SizedBox(height: 2.h),
          _buildEmptyCommentsState(),
        ],
      ],
    );
  }

  Widget _buildAddCommentSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: _commentController,
            focusNode: _commentFocusNode,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add a comment or question about this project...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _commentController.clear();
                  _commentFocusNode.unfocus();
                },
                child: Text('Cancel'),
              ),
              SizedBox(width: 2.w),
              ElevatedButton(
                onPressed: _submitComment,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'send',
                      size: 16,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                    SizedBox(width: 1.w),
                    Text('Post Comment'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    final displayComments =
        _isExpanded ? widget.comments : widget.comments.take(3).toList();

    return Column(
      children:
          displayComments.map((comment) => _buildCommentItem(comment)).toList(),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    final String author = comment['author'] as String;
    final String content = comment['content'] as String;
    final String timestamp = comment['timestamp'] as String;
    final String role = comment['role'] as String? ?? 'user';
    final List<dynamic> replies = comment['replies'] as List<dynamic>? ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                child: Text(
                  author.substring(0, 1).toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          author,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        _buildRoleBadge(role),
                      ],
                    ),
                    Text(
                      timestamp,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            content,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  // Reply functionality would go here
                },
                icon: CustomIconWidget(
                  iconName: 'reply',
                  size: 16,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                label: Text(
                  'Reply',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          // Replies
          if (replies.isNotEmpty) ...[
            SizedBox(height: 2.h),
            ...replies
                .map((reply) => _buildReplyItem(reply as Map<String, dynamic>))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyItem(Map<String, dynamic> reply) {
    final String author = reply['author'] as String;
    final String content = reply['content'] as String;
    final String timestamp = reply['timestamp'] as String;

    return Container(
      margin: EdgeInsets.only(left: 8.w, top: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                author,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                timestamp,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            content,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color badgeColor;
    String displayRole;

    switch (role.toLowerCase()) {
      case 'admin':
        badgeColor = AppTheme.errorLight;
        displayRole = 'Admin';
        break;
      case 'ngo':
        badgeColor = AppTheme.lightTheme.colorScheme.primary;
        displayRole = 'NGO';
        break;
      case 'company':
        badgeColor = AppTheme.lightTheme.colorScheme.secondary;
        displayRole = 'Company';
        break;
      default:
        badgeColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        displayRole = 'User';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        displayRole,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildEmptyCommentsState() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'chat_bubble_outline',
            size: 48,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            'No comments yet',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Be the first to comment on this project',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
