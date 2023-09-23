import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/model/order_model.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/util.dart';

class OrderSuccesPage extends StatelessWidget {
  const OrderSuccesPage({
    super.key,
    required this.data,
  });

  final OrderModel data;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDeffaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Image.asset('assets/icons/checklist_done.png'),
                ),
              ),
              const SizedBox(
                height: kSmallPadding,
              ),
              Text(
                'Nice!',
                style: textTheme.headlineMedium!.copyWith(
                  color: kTextColor3.withOpacity(0.9),
                ),
              ),
              Text(
                'Order success',
                style: textTheme.titleMedium,
              ),
              const SizedBox(
                height: kDeffaultPadding,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(
                    width: kSmallPadding,
                  ),
                  const Expanded(child: Divider()),
                  const SizedBox(
                    width: kSmallPadding,
                  ),
                  Text(
                    currencyFormat(data.totalPrice!),
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: kDeffaultPadding * 2,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  alignment: Alignment.centerLeft,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () => context.pushNamed(Routes.traffic),
                child: const Padding(
                  padding: EdgeInsets.only(left: kDeffaultPadding),
                  child: Text(
                    'See Traffic',
                  ),
                ),
              ),
              const SizedBox(
                height: kSmallPadding,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green.shade800,
                  alignment: Alignment.centerLeft,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.only(left: kDeffaultPadding),
                  child: Text(
                    'See Receipt',
                  ),
                ),
              ),
              const SizedBox(
                height: kSmallPadding,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black54,
                  alignment: Alignment.centerLeft,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () => context.pop(),
                child: const Padding(
                  padding: EdgeInsets.only(left: kDeffaultPadding),
                  child: Text(
                    'Back',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
