import 'package:flutter/material.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          'Hi, I am Finova Support. Ask me anything about using the app, like expenses, budgets, notifications, AI insights, profile, or Pro features.',
      isUser: false,
    ),
  ];

  final List<String> _quickQuestions = const [
    'How do I add expense?',
    'Budget alerts not working',
    'How do AI insights work?',
    'Change reminder time',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? text]) {
    final message = (text ?? _controller.text).trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: message, isUser: true));
      _messages.add(_ChatMessage(text: _answerFor(message), isUser: false));
    });

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _answerFor(String input) {
    final text = input.toLowerCase();

    if (_isOffTopic(text)) {
      return 'I can help only with Finova AI app questions. Try asking about adding expenses, budgets, alerts, analytics, AI insights, account settings, or support options.';
    }

    if (_hasAny(text, ['add expense', 'expense', 'transaction', 'spending'])) {
      return 'To add an expense, open the Add screen, enter the amount, choose a category, add any note you need, then save it. The app uses saved expenses for analytics, budgets, and AI insights.';
    }

    if (_hasAny(text, ['budget', 'limit', 'over budget', 'exceed'])) {
      return 'Budgets are managed from Profile > Manage Budget. Set a monthly amount for each category. Finova compares your current month spending with those limits and can show alerts when spending goes over.';
    }

    if (_hasAny(text, ['notification', 'alert', 'reminder', 'push'])) {
      return 'Open Profile > Push Notification to enable reminders, budget exceed alerts, category limit alerts, and AI smart alerts. Also make sure Android notification permission is allowed for Finova in your phone settings.';
    }

    if (_hasAny(text, ['ai', 'insight', 'prediction', 'forecast', 'smart'])) {
      return 'AI insights use your saved income, budgets, and transactions to find spending trends, forecast risk, and suggest budget improvements. Add a few expenses first so the insights have enough data.';
    }

    if (_hasAny(text, ['analytics', 'chart', 'report', 'history'])) {
      return 'Use Analytics to review spending charts and category breakdowns. Use History to see past transactions and open a transaction for more details.';
    }

    if (_hasAny(text, ['profile', 'account', 'name', 'email', 'privacy'])) {
      return 'Profile contains your account options, budgets, notifications, FAQs, privacy policy, terms, and support. For account details, open Profile and choose the option you want to manage.';
    }

    if (_hasAny(text, ['pro', 'subscription', 'upgrade', 'premium'])) {
      return 'Finova AI Pro unlocks advanced app features such as deeper analytics, AI assistance, and priority support. You can review Pro details from the Upgrade Pro or Subscription section.';
    }

    if (_hasAny(text, ['login', 'sign in', 'signup', 'password', 'google'])) {
      return 'For sign-in help, check your internet connection, confirm the email or Google account, then try again. If the issue continues, use Email Support from Help & Support.';
    }

    if (_hasAny(text, ['contact', 'email', 'support', 'problem', 'bug'])) {
      return 'You can chat here for app guidance. For account-specific issues or bug reports, go back to Help & Support and choose Email Support or Report a Problem.';
    }

    return 'I can help with Finova AI features. You can ask things like "how to add expense", "how to set budget", "why notifications are not working", or "how AI insights work".';
  }

  bool _hasAny(String text, List<String> words) {
    return words.any(text.contains);
  }

  bool _isOffTopic(String text) {
    const appWords = [
      'finova',
      'app',
      'expense',
      'transaction',
      'budget',
      'income',
      'category',
      'notification',
      'alert',
      'reminder',
      'ai',
      'insight',
      'prediction',
      'analytics',
      'history',
      'profile',
      'account',
      'support',
      'email',
      'problem',
      'bug',
      'pro',
      'subscription',
      'login',
      'sign',
      'password',
      'privacy',
      'terms',
    ];

    const clearlyOutsideApp = [
      'weather',
      'movie',
      'song',
      'recipe',
      'cricket',
      'football',
      'news',
      'code',
      'homework',
      'travel plan',
      'medical',
      'legal',
    ];

    final mentionsAppTopic = appWords.any(text.contains);
    final outside = clearlyOutsideApp.any(text.contains);
    return outside && !mentionsAppTopic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
        surfaceTintColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        toolbarHeight: 64,
        title: const Text(
          'Support Chat',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'SFProText',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 58,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final question = _quickQuestions[index];
                return ActionChip(
                  label: Text(
                    question,
                    style: const TextStyle(
                      fontFamily: 'SFProText',
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue.shade100),
                  onPressed: () => _sendMessage(question),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: _quickQuestions.length,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _ChatBubble(message: _messages[index]);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Ask about Finova AI',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontFamily: 'SFProText',
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_rounded),
                    tooltip: 'Send',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.isUser ? Colors.blueAccent : Colors.white;
    final textColor = message.isUser ? Colors.white : Colors.black87;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            height: 1.35,
            fontFamily: 'SFProText',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
