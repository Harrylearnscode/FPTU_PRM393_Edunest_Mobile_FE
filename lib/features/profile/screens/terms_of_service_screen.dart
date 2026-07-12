import 'package:flutter/material.dart';

import '../../../core/ui_text.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.termsOfService),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Header(
            title: 'TERMS OF SERVICE',
            intro:
                'By registering, accessing, or using EduNest, you confirm that you have read, understood, and agreed to these Terms of Service, including our data collection and privacy practices.',
          ),
          const SizedBox(height: 12),
          ..._enTerms.map((term) => _TermSection(term: term)),
          const SizedBox(height: 24),
          Text(
            'Please read and review the EduNest Terms of Service carefully before using the platform.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String intro;

  const _Header({
    required this.title,
    required this.intro,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Platform: EduNest'),
            const Text('Effective Date: [Enter effective date]'),
            const Text('Operated by: [Team/Company/Individual name]'),
            const Text('Support Email: [Support email]'),
            const SizedBox(height: 12),
            Text(intro),
          ],
        ),
      ),
    );
  }
}

class _TermSection extends StatelessWidget {
  final _Term term;

  const _TermSection({required this.term});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              term.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            SelectableText(
              term.body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    letterSpacing: 0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Term {
  final String title;
  final String body;

  const _Term(this.title, this.body);
}

const _enTerms = [
  _Term(
    '1. Introduction to EduNest',
    'EduNest connects learners with tutors. Users can search for courses, schedule sessions, make payments, attend lessons, track attendance, chat, and submit reports when issues arise. Tutors are independent education providers on the platform.',
  ),
  _Term(
    '2. User Roles',
    'EduNest supports parent/student and tutor roles. Learners can book and pay. Tutors can create courses, manage lessons, and communicate with learners inside the platform.',
  ),
  _Term(
    '3. Accounts and Email Verification',
    'Users must register with a valid email and verify it before using full platform features. Users are responsible for account security and all activity under their account.',
  ),
  _Term(
    '4. Account and Data Deletion',
    'Users may request deletion of their account and personal data. Data will be deleted or anonymized within a reasonable period except where retention is required by law, fraud prevention, or pending transactions.',
  ),
  _Term(
    '5. Tutors',
    'Tutors must provide accurate profile, course, and contact information. False or misleading information may result in account suspension.',
  ),
  _Term(
    '6. Courses and Schedules',
    'Tutors may create courses with subject, level, format, schedule, number of sessions, and tuition. Tutors are responsible for accurate and feasible course information.',
  ),
  _Term(
    '7. Bookings and Payments',
    'Learners should review course details before booking. Payments may be processed through PayOS, VietQR, or other integrated methods. Confirmed payment updates booking status and creates lesson sessions.',
  ),
  _Term(
    '8. Cancellations, Refunds, and Disputes',
    'Cancellations, refunds, and disputes depend on booking status, lesson timing, and supporting evidence. EduNest may refuse refunds when a lesson has occurred or the request lacks valid evidence.',
  ),
  _Term(
    '9. Lessons and Attendance',
    'Tutors provide lesson links, attend on time, record attendance, and complete lessons. Learners join on time, prepare devices, and notify tutors in advance when unable to attend.',
  ),
  _Term(
    '10. Chat and Communication',
    'Chat is for educational purposes only. Users must not harass, threaten, spam, commit fraud, exchange illegal content, or request off-platform payments.',
  ),
  _Term(
    '11. Reports and Enforcement',
    'Learners may submit reports with truthful information and evidence. False or harmful reports may result in account restrictions.',
  ),
  _Term(
    '12. Learning Materials',
    'Tutors must ensure uploaded materials do not infringe copyright or contain harmful content. Learners may not redistribute materials beyond personal study without permission.',
  ),
  _Term(
    '13. Personal Data and Security',
    'EduNest processes account, transaction, chat, and usage data to operate the platform, process payments, resolve disputes, and protect security. EduNest does not sell personal data for advertising.',
  ),
  _Term(
    '14. Third-Party Services',
    'EduNest may use PayOS, VietQR, Cloudinary, Render, and email services. These providers process data for service delivery and under their own policies.',
  ),
  _Term(
    '15. Suspension or Termination',
    'EduNest may suspend or terminate accounts for terms violations, false information, fraud, harm to others, platform abuse, or legal violations.',
  ),
  _Term(
    '16. Governing Law and Disputes',
    'These terms are governed by Vietnamese law. Disputes should first be resolved through negotiation and may be referred to competent authorities when necessary.',
  ),
  _Term(
    '17. Contact',
    'For questions about these terms or personal data, contact the support email listed in the app. EduNest will respond as soon as reasonably possible.',
  ),
];
