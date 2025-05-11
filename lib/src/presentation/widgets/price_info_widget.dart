import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testflutterapp/src/data/repositories/order_repository.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/secondary_button.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/app_styles.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';

class PriceInfoWidget extends StatelessWidget {
  final VoidCallback onTap;
  const PriceInfoWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        height: 263,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppStyles.largeBorderRadius,
          boxShadow: [AppStyles.boxShadow7],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                'assets/svg/pattern-card.svg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: CustomTextStyle.size16Weight400Text(
                          Colors.white,
                        ),
                      ),
                      Text(
                        '${OrderRepository.subtotal} DT',
                        style: CustomTextStyle.size16Weight400Text(
                          Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery fee',
                        style: CustomTextStyle.size16Weight400Text(
                          Colors.white,
                        ),
                      ),
                      Text(
                        '${OrderRepository.deliveryFee} DT',
                        style: CustomTextStyle.size16Weight400Text(
                          Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount',
                        style: CustomTextStyle.size16Weight400Text(
                          Colors.white,
                        ),
                      ),
                      Text(
                        '${OrderRepository.discount} DT',
                        style: CustomTextStyle.size16Weight400Text(
                          Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: CustomTextStyle.size22Weight600Text(
                          Colors.white,
                        ),
                      ),
                      Text(
                        '${OrderRepository.total.toStringAsFixed(2)} DT',
                        style: CustomTextStyle.size22Weight600Text(
                          Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: "Place Order",
                          onTap: onTap,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
