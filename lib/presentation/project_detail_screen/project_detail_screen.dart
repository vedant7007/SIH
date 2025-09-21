import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_verification_widget.dart';
import './widgets/comments_section_widget.dart';
import './widgets/document_attachments_widget.dart';
import './widgets/project_image_gallery_widget.dart';
import './widgets/project_info_section_widget.dart';
import './widgets/project_map_widget.dart';
import './widgets/project_status_badge_widget.dart';
import './widgets/role_based_actions_widget.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  // Mock data for the project
  final Map<String, dynamic> projectData = {
    "id": "PRJ-2024-001",
    "title": "Mangrove Restoration Initiative - Sundarbans Delta",
    "location": "Sundarbans, West Bengal, India",
    "submissionDate": "15 Sep 2024",
    "status": "under_review",
    "description":
        """This comprehensive mangrove restoration project aims to rehabilitate 500 hectares of degraded coastal wetlands in the Sundarbans Delta region. The initiative focuses on planting native mangrove species including Rhizophora mucronata, Avicennia marina, and Sonneratia apetala to restore critical ecosystem services.

The project will directly benefit local fishing communities by improving fish breeding grounds, reducing coastal erosion, and providing sustainable livelihood opportunities through eco-tourism and sustainable harvesting practices. Our team has conducted extensive soil analysis and hydrological studies to ensure optimal planting locations and species selection.

Expected carbon sequestration: 2,500 tons CO2 equivalent over 10 years. The project includes community engagement programs, regular monitoring protocols, and partnerships with local environmental organizations to ensure long-term sustainability and success.""",
    "images": [
      "https://images.pexels.com/photos/1108701/pexels-photo-1108701.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/1029604/pexels-photo-1029604.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/1029896/pexels-photo-1029896.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    ],
    "coordinates": {"latitude": 21.9497, "longitude": 88.1905},
    "aiVerification": {
      "overallConfidence": 0.87,
      "results": [
        {
          "category": "Image Authenticity",
          "score": 0.92,
          "status":
              "High confidence - Images show consistent metadata and environmental conditions"
        },
        {
          "category": "Location Verification",
          "score": 0.89,
          "status":
              "GPS coordinates match satellite imagery and regional characteristics"
        },
        {
          "category": "Species Identification",
          "score": 0.85,
          "status":
              "Native mangrove species correctly identified in submitted photographs"
        },
        {
          "category": "Environmental Impact",
          "score": 0.82,
          "status":
              "Projected carbon sequestration estimates align with scientific models"
        }
      ],
      "flaggedConcerns": [
        "Seasonal variation in water levels may affect planting success rates",
        "Community engagement documentation could be more comprehensive"
      ]
    },
    "documents": [
      {
        "name": "Environmental Impact Assessment.pdf",
        "type": "pdf",
        "size": 2457600,
        "uploadDate": "12 Sep 2024",
        "url": "https://example.com/documents/eia.pdf"
      },
      {
        "name": "Community Consent Letters.pdf",
        "type": "pdf",
        "size": 1024000,
        "uploadDate": "14 Sep 2024",
        "url": "https://example.com/documents/consent.pdf"
      },
      {
        "name": "Species Planting Plan.xlsx",
        "type": "xlsx",
        "size": 512000,
        "uploadDate": "13 Sep 2024",
        "url": "https://example.com/documents/planting_plan.xlsx"
      }
    ]
  };

  // Current user role - this would typically come from authentication
  UserRole currentUserRole = UserRole.admin;

  // Comments data
  List<Map<String, dynamic>> comments = [
    {
      "id": "1",
      "author": "Dr. Priya Sharma",
      "role": "admin",
      "content":
          "The environmental impact assessment looks comprehensive. However, I'd like to see more details about the long-term monitoring plan for the restored areas.",
      "timestamp": "2 hours ago",
      "replies": [
        {
          "id": "1-1",
          "author": "Rajesh Kumar",
          "content":
              "Thank you for the feedback. We'll submit the detailed monitoring protocol by tomorrow.",
          "timestamp": "1 hour ago"
        }
      ]
    },
    {
      "id": "2",
      "author": "Green Earth Foundation",
      "role": "ngo",
      "content":
          "This project aligns perfectly with our coastal conservation goals. The community engagement approach is particularly impressive.",
      "timestamp": "5 hours ago",
      "replies": []
    },
    {
      "id": "3",
      "author": "EcoTech Solutions",
      "role": "company",
      "content":
          "We're interested in purchasing carbon credits from this project once it's approved. What's the expected timeline for verification?",
      "timestamp": "1 day ago",
      "replies": []
    }
  ];

  void _handleAddComment(String comment) {
    setState(() {
      comments.insert(0, {
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "author": "Current User",
        "role": currentUserRole.name,
        "content": comment,
        "timestamp": "Just now",
        "replies": []
      });
    });
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Project link copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleEdit() {
    Navigator.pushNamed(context, '/project-submission-screen');
  }

  void _handleDuplicate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Project duplicated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleApprove() {
    setState(() {
      projectData['status'] = 'approved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Project approved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleReject() {
    setState(() {
      projectData['status'] = 'rejected';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Project rejected'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleRequestInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Information request sent to project submitter'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handlePurchaseCredits() {
    Navigator.pushNamed(context, '/carbon-credit-marketplace-screen');
  }

  @override
  Widget build(BuildContext context) {
    final String status = projectData['status'] as String;
    final List<String> images = (projectData['images'] as List).cast<String>();
    final Map<String, dynamic> coordinates =
        projectData['coordinates'] as Map<String, dynamic>;
    final Map<String, dynamic> aiVerification =
        projectData['aiVerification'] as Map<String, dynamic>;
    final List<Map<String, dynamic>> documents =
        (projectData['documents'] as List).cast<Map<String, dynamic>>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 30.h,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'share',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: _handleShare,
              ),
              SizedBox(width: 2.w),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: images.isNotEmpty
                  ? CustomImageWidget(
                      imageUrl: images.first,
                      width: double.infinity,
                      height: 30.h,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'image',
                          size: 64,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProjectStatusBadgeWidget(
                        status: status,
                        isLarge: true,
                      ),
                      Text(
                        'ID: ${projectData['id']}',
                        style: AppTheme.getDataTextStyle(
                          isLight: true,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ).copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Project Info Section
                  ProjectInfoSectionWidget(
                    title: projectData['title'] as String,
                    location: projectData['location'] as String,
                    submissionDate: projectData['submissionDate'] as String,
                    status: status,
                    description: projectData['description'] as String,
                  ),
                  SizedBox(height: 4.h),

                  // Image Gallery
                  if (images.isNotEmpty) ...[
                    Text(
                      'Project Gallery',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ProjectImageGalleryWidget(
                      images: images,
                      heroTag: 'project_${projectData['id']}',
                    ),
                    SizedBox(height: 4.h),
                  ],

                  // Project Location Map
                  ProjectMapWidget(
                    latitude: (coordinates['latitude'] as num).toDouble(),
                    longitude: (coordinates['longitude'] as num).toDouble(),
                    projectTitle: projectData['title'] as String,
                  ),
                  SizedBox(height: 4.h),

                  // AI Verification (Admin only)
                  if (currentUserRole == UserRole.admin) ...[
                    AIVerificationWidget(
                      overallConfidence:
                          (aiVerification['overallConfidence'] as num)
                              .toDouble(),
                      verificationResults: (aiVerification['results'] as List)
                          .cast<Map<String, dynamic>>(),
                      flaggedConcerns:
                          (aiVerification['flaggedConcerns'] as List)
                              .cast<String>(),
                    ),
                    SizedBox(height: 4.h),
                  ],

                  // Document Attachments
                  DocumentAttachmentsWidget(
                    documents: documents,
                  ),
                  SizedBox(height: 4.h),

                  // Role-based Actions
                  RoleBasedActionsWidget(
                    userRole: currentUserRole,
                    projectStatus: status,
                    onEdit: _handleEdit,
                    onDuplicate: _handleDuplicate,
                    onShare: _handleShare,
                    onApprove: _handleApprove,
                    onReject: _handleReject,
                    onRequestInfo: _handleRequestInfo,
                    onPurchaseCredits: _handlePurchaseCredits,
                  ),
                  SizedBox(height: 4.h),

                  // Comments Section
                  CommentsSectionWidget(
                    comments: comments,
                    onAddComment: _handleAddComment,
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
