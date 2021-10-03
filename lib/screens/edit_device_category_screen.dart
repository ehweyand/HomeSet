import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/categories.dart';

class EditDeviceCategoryScreen extends StatefulWidget {
  static const routeName = '/edit-device-category';

  @override
  _EditDeviceCategoryState createState() => _EditDeviceCategoryState();
}

class _EditDeviceCategoryState extends State<EditDeviceCategoryScreen> {
  final _form = GlobalKey<FormState>();

  var _editedCategory = Category(
    id: null,
    description: '',
  );

  var _initValues = {
    'description': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final categoryId = ModalRoute.of(context).settings.arguments as String;
      if (categoryId != null) {
        _editedCategory = Provider.of<Categories>(context, listen: false)
            .findById(categoryId);
        _initValues = {
          'description': _editedCategory.description,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedCategory.id != null) {
      await Provider.of<Categories>(context, listen: false)
          .updateCategory(_editedCategory.id, _editedCategory);
    } else {
      try {
        await Provider.of<Categories>(context, listen: false)
            .addCategory(_editedCategory);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Erro!'),
            content: Text(
                'Algo errado aconteceu. Mensagem técnica: ' + error.toString()),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('OK'),
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edição de categoria'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['description'],
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        errorStyle: TextStyle(fontSize: 14),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Digite a descrição';
                        }
                        if (value.length < 10) {
                          return 'A descrição precisa ter pelo menos 10 caracteres.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCategory = Category(
                          id: _editedCategory.id,
                          description: value,
                        );
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
