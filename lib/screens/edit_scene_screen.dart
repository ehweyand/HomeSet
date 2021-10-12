import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scene.dart';
import '../providers/scenes.dart';

class EditSceneScreen extends StatefulWidget {
  static const routeName = '/edit-scene';

  @override
  _EditSceneScreenState createState() => _EditSceneScreenState();
}

class _EditSceneScreenState extends State<EditSceneScreen> {
  final _form = GlobalKey<FormState>();

  // campos da cena
  var _editedScene = Scene(
    id: null,
    nickname: '',
    description: '',
  );

  var _initValues = {
    'nickname': '',
    'description': '',
  };

  final _nicknameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // Colocaria aqui a lógica para implementar a edição de cena
    // Capturando os parâmetros recebidos pela rota
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nicknameFocusNode.dispose();
    _descriptionFocusNode.dispose();
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

    try {
      await Provider.of<Scenes>(context, listen: false).addScene(_editedScene);
    } catch (error) {
      //Mostrar o erro pro usuário
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro!'),
          content: Text(
              'Algo errado aconteceu. Mensagem técnica: ' + error.toString()),
          actions: [
            FlatButton(
              onPressed: () {
                //fechar a dialog
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            )
          ],
        ),
      );
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
        title: Text('Edição de cena'),
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
                      initialValue: _initValues['nickname'],
                      decoration: InputDecoration(
                        labelText: 'Nome da cena',
                        errorStyle: TextStyle(fontSize: 14),
                      ),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Digite o nome da cena';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedScene = Scene(
                          id: _editedScene.id,
                          nickname: value,
                          description: _editedScene.description,
                          isFavorite: _editedScene.isFavorite,
                        );
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
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
                        _editedScene = Scene(
                          id: _editedScene.id,
                          nickname: _editedScene.nickname,
                          description: value,
                          isFavorite: _editedScene.isFavorite,
                        );
                      },
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
