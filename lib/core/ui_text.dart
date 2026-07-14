import 'package:flutter/widgets.dart';

class UiText {
  const UiText();

  static UiText of(BuildContext context, {bool listen = true}) {
    return const UiText();
  }

  String get appName => 'EduNest';
  String get home => 'Home';
  String get booking => 'Booking';
  String get course => 'Course';
  String get chat => 'Chat';
  String get profile => 'Profile';
  String get lesson => 'Lesson';
  String get homework => 'Homework';
  String get materials => 'Materials';
  String get section => 'Section';
  String get noMaterialCoursesTutor =>
      'No courses are available for materials yet.';
  String get noMaterialCoursesLearner =>
      'No enrolled courses are available yet.';
  String get noCoursesAvailableYet => 'No courses available yet.';
  String get noHomeworkHere => 'No homework here yet.';
  String get courseTools => 'Course tools';
  String get language => 'Language';
  String get refresh => 'Refresh';
  String get vietnamese => 'Vietnamese';
  String get english => 'English';
  String get login => 'Login';
  String get signUp => 'Sign up';
  String get welcomeBack => 'Welcome back';
  String get chooseYourRole => 'Choose your role';
  String get tutor => 'Tutor';
  String get parentStudent => 'Student';
  String get teach => 'Teach';
  String get learn => 'Learn';
  String get email => 'Email';
  String get password => 'Password';
  String get hidePassword => 'Hide password';
  String get showPassword => 'Show password';
  String get emailRequired => 'Email is required';
  String get passwordRequired => 'Password is required';
  String get invalidEmail => 'Invalid email';
  String get passwordTooShort => 'Password must be at least 6 characters';
  String get requiredField => 'Required';
  String get createAccount => 'Create account';
  String get registerAs => 'Register as';
  String get parent => 'Parent';
  String get student => 'Student';
  String get fullName => 'Full name';
  String get phone => 'Phone';
  String get tutorBio => 'Tutor bio';
  String get shortIntro => 'Short intro';
  String get school => 'School';
  String get address => 'Address';
  String get verifyYourEmail => 'Please verify your email.';
  String get verify => 'Verify';
  String get checkYourEmail => 'Check your email';
  String get verificationCode => 'Verification code';
  String get code => 'Code';
  String get verificationCodeRequired => 'Verification code is required';
  String get emailVerified => 'Email verified successfully. Please login.';
  String get verificationCodeResent =>
      'Verification code resent. Check your email.';
  String get resendCode => 'Resend code';
  String get myCourses => 'My Courses';
  String get exploreTutors => 'Explore Tutors';
  String get favoriteTutors => 'Favorite tutors';
  String get noCoursesAvailable => 'No Courses Available';
  String get startSharingKnowledge =>
      'Start sharing your knowledge with students today.';
  String get active => 'Active';
  String get hidden => 'Hidden';
  String get lessonsLower => 'lessons';
  String get totalTuition => 'Total Tuition';
  String get hide => 'Hide';
  String get publish => 'Publish';
  String get hideCourseTitle => 'Hide Course?';
  String get publishCourseTitle => 'Publish Course?';
  String get hideCourseMessage =>
      'Students will no longer be able to find or book this course.';
  String get publishCourseMessage =>
      'Students will be able to find and book this course open for registration.';
  String get cancel => 'Cancel';
  String get courseStatusUpdated => 'Course status updated successfully';
  String get noTutorsAvailable => 'No tutors are currently available.';
  String activeCoursesOpen(int count) => '$count active courses open';
  String get unsaveTutor => 'Unsave tutor';
  String get saveTutor => 'Save tutor';
  String get viewTutorProfile => 'View tutor profile';
  String get tutorSaved => 'Tutor saved';
  String get tutorRemoved => 'Tutor removed from favorites';
  String get fullTuitionPackage => 'Full Tuition Package';
  String get enrollNow => 'Enroll Now';
  String get enrolledSuccessfully => 'Enrolled in class successfully!';
  String get personalProfile => 'Personal Profile';
  String get logOut => 'Log Out';
  String get personalInformation => 'Personal Information';
  String get emailAddress => 'Email Address';
  String get phoneNumber => 'Phone Number';
  String get biographyTutor => 'Biography / Introduction (Tutor)';
  String get saveChanges => 'Save Changes';
  String get profileUpdated => 'Profile updated successfully';
  String get bankAccountUpdated => 'Bank account updated successfully';
  String get avatarUpdated => 'Avatar updated successfully';
  String couldNotUploadAvatar(Object error) =>
      'Could not upload avatar: $error';
  String get noAvatarToDelete => 'No avatar to delete';
  String get deleteAvatarTitle => 'Delete avatar?';
  String get deleteAvatarMessage => 'Your profile image will be removed.';
  String get delete => 'Delete';
  String get avatarDeleted => 'Avatar deleted';
  String get uploadUpdateAvatar => 'Upload / Update avatar';
  String get deleteAvatar => 'Delete avatar';
  String get languagePreference => 'Language preference';
  String get chooseAppLanguage => 'Choose the display language for the app.';
  String get bankAccountDetails => 'Bank Account Details';
  String get bankBinInfo => 'Bank BIN is used for Vietnamese bank selection.';
  String get bankName => 'Bank Name';
  String get bankBin => 'Bank BIN';
  String get accountNumber => 'Account Number';
  String get accountHolderName => 'Account Holder Name';
  String get bankBranchOptional => 'Bank Branch (Optional)';
  String get saveBankInformation => 'Save Bank Information';
  String get myReports => 'My Reports';
  String get myReportsSubtitle =>
      'Track tutor reports you submitted and view progress.';
  String get termsOfService => 'Terms of Service';
  String get termsOfServiceSubtitle =>
      'Read EduNest rules for payments, reports, tutors, and account policies.';

  String get myBookings => 'My Bookings';
  String get noBookingsFound => 'No Bookings Found';
  String get bookingsEmptyMessage =>
      'Your registered classes or scheduled sessions will appear here.';
  String get bookingId => 'Booking ID';
  String get tutorId => 'Tutor ID';
  String get availabilityId => 'Availability ID';
  String get tuitionFee => 'Tuition Fee';
  String get payNow => 'Pay Now';
  String get paid => 'Paid';
  String get completed => 'Completed';
  String get cancelled => 'Cancelled';
  String get expired => 'Expired';
  String get failed => 'Failed';
  String get unavailable => 'Unavailable';
  String get pending => 'Pending';
  String get confirmed => 'Confirmed';
  String get cancelBooking => 'Cancel Booking';
  String get reportTutor => 'Report Tutor';
  String get reviewed => 'Reviewed';
  String get reviewTutor => 'Review Tutor';
  String get reviewSubmitted => 'Review submitted';
  String get cancelBookingTitle => 'Cancel Booking Request?';
  String get cancelBookingMessage =>
      'This action will cancel the pending booking request. You can book this slot again later if needed.';
  String get keepBooking => 'Keep Booking';
  String get confirmCancel => 'Confirm Cancel';
  String get bookingCancelled => 'Booking request cancelled successfully';

  String get lessonsTitle => 'Lessons';
  String get myTeachingLessons => 'My teaching lessons';
  String get myLearningLessons => 'My learning lessons';
  String get noLessonsYet => 'No lessons yet. Pay a booking first.';
  String get attendanceReminder => 'Attendance reminder';
  String get attendanceReminderMessage =>
      'These lessons have ended but are not completed yet. Open the detail page, take attendance, then complete the lesson.';
  String get open => 'Open';
  String get nextLesson => 'Next lesson';
  String get openLessonDetail => 'Open lesson detail';
  String get openDetail => 'Open detail';
  String get endedTakeAttendance =>
      'Ended. Take attendance and complete this lesson.';
  String get lessonStartedCompletionLater =>
      'Lesson started. Completion unlocks after end time.';
  String get startsLater => 'Starts later';
  String get couldNotOpenMeeting => 'Could not open meeting link';
  String get invalidMeetingLink => 'Invalid meeting link';
  String get openMeeting => 'Open meeting';
  String get meetingLinkNotAdded => 'Meeting link not added yet';
  String get couldNotOpenFile => 'Could not open this material';
  String tutorName(String name) => 'Tutor: $name';
  String students(int count) => '$count student${count == 1 ? '' : 's'}';
  String lessonsN(int count) => '$count lesson${count == 1 ? '' : 's'}';
  String materialsN(int count) => '$count material${count == 1 ? '' : 's'}';
  String points(Object value) => '$value pts';
  String dueAt(String value) => 'Due $value';
  String submittedAt(String value) => 'Submitted $value';
  String lessonWithTutor(String value, String tutorName) =>
      '$value lesson with $tutorName';
  String sessionsN(int count) => '$count session${count == 1 ? '' : 's'}';
  String coursesN(int count) => '$count course${count == 1 ? '' : 's'}';
  String studentRows(int count) => '$count student rows';
  String availabilityNumber(Object id) => 'Availability #$id';
  String bookingDuration(Object bookingId, Object minutes) =>
      'Booking #$bookingId - $minutes min';
  String moreSessionsNeedAttention(int count) =>
      '+$count more session${count == 1 ? '' : 's'} need attention.';
  String deleteSectionMessage(String title) =>
      'Delete "$title" and all materials inside it?';
  String deleteMaterialMessage(String title) => 'Delete "$title"?';

  String rangeOf(int start, int end, int total) => '$start-$end of $total';

  String get userEmail => 'User email';
  String get enterValidUserEmail => 'Enter a valid user email';
  String get start => 'Start';
  String conversationNumber(int id) => 'Conversation #$id';
  String get noMessagesYet => 'No messages yet.';
  String get startConversation => 'Start the conversation';
  String get you => 'You';
  String get messageHint => 'Type a message...';
  String get restrictedChatWarning =>
      'For your safety, keep communication and payment inside EduNest.';

  String get bankBinHint => 'Example: 970422';
  String get bankBinHelper => 'Use a valid Vietnamese bank BIN.';
  String get viewBankBinList => 'View bank BIN list';
  String get bankBinRequired => 'Bank BIN is required';
  String get validVietnamBankBin => 'Please select a valid Vietnamese bank BIN';
  String get searchBank => 'Search bank';
  String get searchBankHint => 'Search by name, code, or BIN';
  String get selectRealBankBin => 'Select a valid bank BIN.';

  String reviewTutorName(String name) => 'Review $name';
  String bookingNumber(int id) => 'Booking #$id';
  String starTooltip(int value) => '$value star';
  String get comment => 'Comment';
  String get reviewHint => 'Share what worked well or what could improve';
  String get sending => 'Sending...';
  String get submit => 'Submit';
  String get thisFieldRequired => 'This field is required';

  String role(String role) {
    switch (role.toLowerCase()) {
      case 'tutor':
        return 'TUTOR';
      case 'learner':
        return 'LEARNER';
      default:
        return role.isEmpty ? ('USER') : role.toUpperCase();
    }
  }

  String authFlowTitle(bool isTutor) => isTutor ? tutor : parentStudent;

  String text(String source) => source;

  String status(String value) {
    switch (value.trim().toLowerCase()) {
      case 'pending':
        return pending;
      case 'paid':
        return paid;
      case 'confirmed':
        return confirmed;
      case 'completed':
      case 'complete':
        return completed;
      case 'cancelled':
      case 'canceled':
        return cancelled;
      case 'expired':
        return expired;
      case 'failed':
        return failed;
      case 'active':
        return active;
      case 'inactive':
      case 'hidden':
        return hidden;
      case 'approved':
        return 'Approved';
      case 'processing':
        return 'Processing';
      case 'reviewing':
        return 'Reviewing';
      case 'resolved':
        return 'Resolved';
      case 'rejected':
        return 'Rejected';
      case 'present':
        return 'Present';
      case 'absent':
        return 'Absent';
      case 'late':
        return 'Late';
      case 'notstarted':
      case 'not started':
        return 'Not started';
      default:
        return value;
    }
  }

  String mode(String value) {
    switch (value.trim().toLowerCase()) {
      case 'online':
        return 'Online';
      case 'offline':
        return 'Offline';
      case 'hybrid':
        return 'Hybrid';
      default:
        return value;
    }
  }

  String level(String value) {
    switch (value.trim().toLowerCase()) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return value;
    }
  }
}

extension UiTextX on BuildContext {
  UiText get strings => UiText.of(this);
}
