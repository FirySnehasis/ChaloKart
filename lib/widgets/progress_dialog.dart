import 'dart:async';
import 'package:flutter/material.dart';

class ProgressDialog extends StatefulWidget {
  final String? message;
  final int timeoutSeconds;

  const ProgressDialog({super.key, this.message, this.timeoutSeconds = 15});

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    // Set a timeout to auto-dismiss the dialog if it takes too long
    _timeoutTimer = Timer(Duration(seconds: widget.timeoutSeconds), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.green.shade200, width: 1),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.green.shade300,
                  strokeWidth: 2.5,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                widget.message ?? "Please wait...",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

