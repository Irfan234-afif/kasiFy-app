import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/app/model/category_model.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/util/dialog_collection.dart';
import 'package:kasir_app/app/util/global_function.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../bloc/category/category_bloc.dart';
import '../../theme/app_theme.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late TextEditingController newCategoryC;
  late GlobalKey<FormState> formkey;
  late String token;

  @override
  void initState() {
    newCategoryC = TextEditingController();
    formkey = GlobalKey<FormState>();
    token = '';
    super.initState();
  }

  @override
  void dispose() {
    newCategoryC.dispose();
    super.dispose();
  }

  void _addCategory() {
    if (newCategoryC.text.isNotEmpty) {
      final categoryModel = CategoryModel(
        name: newCategoryC.text,
      );
      context.read<CategoryBloc>().add(CategoryAddEvent(token, categoryModel: categoryModel));
    }
  }

  void _deleteCategory(CategoryModel category) async {
    // initial expression
    final addCategory = context.read<CategoryBloc>();

    // dialog confirm
    bool flag = await DialogCollection.confirmDialog(
      context,
      titleText: 'Delete this category and items?',
    );

    if (flag) {
      addCategory.add(CategoryDeleteEvent(token, categoryModel: category));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product's item category"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: kDeffaultPadding, vertical: kDeffaultPadding),
        child: Column(
          children: [
            _buildTextFieldAddCategory(),
            _buildListCategory(),
          ],
        ),
      ),
    );
  }

  Row _buildTextFieldAddCategory() {
    return Row(
      children: [
        Expanded(
          child: Form(
            key: formkey,
            child: TextFormField(
              controller: newCategoryC,
              style: const TextStyle(
                fontSize: 12,
              ),
              decoration: InputDecoration(
                hintText: 'Input a new category',
                contentPadding: const EdgeInsets.symmetric(horizontal: kDeffaultPadding),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kRadiusDeffault),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kRadiusDeffault),
                  borderSide: const BorderSide(color: kPrimaryColor),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: kSmallPadding,
        ),
        IconButton(
          onPressed: _addCategory,
          icon: const Icon(TablerIcons.plus),
        ),
      ],
    );
  }

  Expanded _buildListCategory() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          GlobalFunction.refresh(context);
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            final categoryModel = state.categoryModel;
            if (state is CategoryLoadingState) {
              // When state Loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CategoryErrorState) {
              // When state Error
              return ListView(
                children: const [
                  Center(
                    child: Text('Terjadi kesalahan'),
                  ),
                ],
              );
            } else if (categoryModel == null || categoryModel.isEmpty) {
              // When data not yet
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Text('Category not yet'),
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: kDeffaultPadding),
                itemCount: categoryModel.length,
                itemBuilder: (context, index) {
                  final category = categoryModel[index];
                  return ListTile(
                    minVerticalPadding: 24,
                    title: Text(
                      category.name!,
                    ),
                    trailing: IconButton(
                      onPressed: () => _deleteCategory(category),
                      icon: const Icon(TablerIcons.trash),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
