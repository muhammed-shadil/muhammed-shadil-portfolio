import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../animations/hover_region.dart';
import '../../animations/reveal.dart';
import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/launcher.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/brand_icons.dart';
import '../../widgets/buttons.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/section_shell.dart';
import '../../widgets/tech_chip.dart';

/// Final call to action: contact details on the left, a message form on the
/// right.
///
/// The site is statically hosted on GitHub Pages, so there is no server to
/// POST to. Rather than pretend, the form validates the input and hands a
/// fully composed message to the visitor's mail client — which is honest, has
/// no third-party dependency, and cannot silently drop a message.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key, this.anchorKey});

  final Key? anchorKey;

  @override
  Widget build(BuildContext context) {
    final isWide = context.screenWidth >= 960;

    return SectionShell(
      anchorKey: anchorKey,
      semanticLabel: 'Contact',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Contact',
            title: PortfolioData.contactTitle,
            highlight: 'something great',
            lead: PortfolioData.contactBlurb,
          ),
          const SizedBox(height: 52),
          if (isWide)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Reveal(child: const _ContactDetails()),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 6,
                    child: Reveal(
                      delay: const Duration(milliseconds: 120),
                      child: const ContactForm(),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Reveal(child: const _ContactDetails()),
            const SizedBox(height: 20),
            Reveal(
              delay: const Duration(milliseconds: 120),
              child: const ContactForm(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.all(context.responsive(mobile: 24.0, laptop: 30.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const StatusBadge(
            label: PortfolioData.availability,
            color: Color(0xFF4ADE80),
            pulse: true,
          ),
          const SizedBox(height: 26),
          Text(
            'Reach me directly',
            style: AppText.subtitle.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 8),
          Text(
            'Email is fastest. I reply within a day or two.',
            style: AppText.bodySmall,
          ),
          const SizedBox(height: 26),
          const _CopyableRow(
            icon: Icons.alternate_email_rounded,
            label: 'Email',
            value: PortfolioData.email,
            url: PortfolioData.mailto,
          ),
          const SizedBox(height: 12),
          const _CopyableRow(
            icon: Icons.call_outlined,
            label: 'Phone',
            value: PortfolioData.phone,
            url: PortfolioData.telUrl,
          ),
          const SizedBox(height: 12),
          const _CopyableRow(
            icon: Icons.place_outlined,
            label: 'Location',
            value: PortfolioData.location,
          ),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 20),
          Text(
            'Elsewhere',
            style: AppText.caption.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              IconActionButton(
                onPressed: () => Launcher.open(PortfolioData.githubUrl),
                tooltip: 'GitHub',
                child: const BrandIcon(BrandPaths.github),
              ),
              const SizedBox(width: 10),
              IconActionButton(
                onPressed: () => Launcher.open(PortfolioData.linkedinUrl),
                tooltip: 'LinkedIn',
                accent: const Color(0xFF0A66C2),
                child: const BrandIcon(BrandPaths.linkedin),
              ),
              const SizedBox(width: 10),
              IconActionButton(
                onPressed: () => Launcher.open(PortfolioData.instagramUrl),
                tooltip: 'Instagram',
                accent: const Color(0xFFE1306C),
                child: const BrandIcon(BrandPaths.instagram),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A detail row that copies its value to the clipboard and, where a URL is
/// given, opens it.
class _CopyableRow extends StatefulWidget {
  const _CopyableRow({
    required this.icon,
    required this.label,
    required this.value,
    this.url,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? url;

  @override
  State<_CopyableRow> createState() => _CopyableRowState();
}

class _CopyableRowState extends State<_CopyableRow> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: widget.url == null ? _copy : () => Launcher.open(widget.url),
      focusable: true,
      semanticLabel: '${widget.label}: ${widget.value}',
      builder: (context, state) {
        final active = state.isActive;

        return AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: AppRadii.mdAll,
            color: Colors.white.withValues(alpha: active ? 0.055 : 0.025),
            border: Border.all(
              color: active ? AppColors.borderStrong : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: active ? AppColors.accentAlt : AppColors.textTertiary,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: AppText.caption.copyWith(fontSize: 10.5),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.value,
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Copy affordance sits inside the row rather than as a second
              // control, so the row stays one tap target on touch.
              GestureDetector(
                onTap: _copy,
                child: Icon(
                  _copied ? Icons.check_rounded : Icons.copy_rounded,
                  size: 14,
                  color: _copied
                      ? const Color(0xFF4ADE80)
                      : active
                      ? AppColors.textSecondary
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Name / email / message, validated, then handed to the mail client.
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  bool _sending = false;
  bool _sent = false;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _sending = true);

    final url = Launcher.composeMail(
      to: PortfolioData.email,
      subject: 'Portfolio enquiry from ${_name.text.trim()}',
      body:
          '${_message.text.trim()}\n\n'
          '—\n'
          '${_name.text.trim()}\n'
          '${_email.text.trim()}',
    );

    final opened = await Launcher.open(url);
    if (!mounted) return;

    setState(() {
      _sending = false;
      _sent = opened;
    });

    if (!opened) {
      // Mail client refused to open — fall back to the clipboard so the
      // visitor still leaves with a way to reach me.
      await Clipboard.setData(const ClipboardData(text: PortfolioData.email));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceHigh,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Could not open your mail app. '
            '${PortfolioData.email} copied to your clipboard instead.',
            style: AppText.bodySmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      accent: AppColors.accent,
      glowStrength: 0.2,
      padding: EdgeInsets.all(context.responsive(mobile: 24.0, laptop: 32.0)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send a message',
              style: AppText.subtitle.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 8),
            Text(
              'This opens your mail app with everything filled in.',
              style: AppText.caption,
            ),
            const SizedBox(height: 26),
            _Field(
              controller: _name,
              label: 'Name',
              hint: 'Your name',
              textInputAction: TextInputAction.next,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 18),
            _Field(
              controller: _email,
              label: 'Email',
              hint: 'you@company.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Please enter your email';
                if (!_emailPattern.hasMatch(text)) {
                  return 'That does not look like an email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            _Field(
              controller: _message,
              label: 'Message',
              hint: 'Tell me about the project or role…',
              maxLines: 5,
              validator: (value) => (value == null || value.trim().length < 10)
                  ? 'A little more detail, please'
                  : null,
            ),
            const SizedBox(height: 26),
            PrimaryButton(
              label: _sent ? 'Message ready' : 'Send message',
              icon: _sent ? Icons.check_rounded : Icons.send_rounded,
              expand: true,
              busy: _sending,
              onPressed: _submit,
            ),
            if (_sent) ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mark_email_read_outlined,
                    size: 14,
                    color: Color(0xFF4ADE80),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Your mail app should be open — just hit send.',
                      style: AppText.caption.copyWith(
                        color: const Color(0xFF4ADE80),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          style: AppText.body.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.5,
          ),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
