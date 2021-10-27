import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device.dart';
import '../providers/devices.dart';

class EditDeviceScreen extends StatefulWidget {
  static const routeName = '/edit-device';

  @override
  _EditDeviceScreenState createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  // Interagir com um widget de dentro do código - Geralmente usada apenas em forms
  final _form = GlobalKey<FormState>();

  // campos do device
  var _editedDevice = Device(
    id: null,
    model: '',
    description: '',
  );

  var _initValues = {
    'model': '',
    'description': '',
  };

  // Trabalho com o focus no campo
  final _descriptionFocusNode = FocusNode();

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // extrair parâmetro do arguments: da rota (enviado via Navigator - pushNamed)
      final deviceId = ModalRoute.of(context).settings.arguments as String;
      if (deviceId != null) {
        // encontra o device com aquele id
        _editedDevice =
            Provider.of<Devices>(context, listen: false).findById(deviceId);
        //valores iniciais
        _initValues = {
          'model': _editedDevice.model,
          'description': _editedDevice.description,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Evitar memory leaks
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

    // Persistir os dados!
    if (_editedDevice.id != null) {
      //é um update
      // para mostrar erro e tratar, usar trycatch aqui
      await Provider.of<Devices>(context, listen: false)
          .updateDevice(_editedDevice.id, _editedDevice);
    } else {
      try {
        //é um insert -- espera executar assíncrono (addDevice é async)
        await Provider.of<Devices>(context, listen: false)
            .addDevice(_editedDevice);
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
        title: Text('Edição de dispositivo'),
        //a ação de salvar o form ficará até o momento exclusiva de um iconbutton na appbar
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      //No body, será criado o formulário para manipular os dados.
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                //para manipular com o state do wigdet Form (Stateful)
                key: _form,
                //múltiplos itens um abaixo do outro, já scrollable (ou column e singlechildscrollview)
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['model'],
                      decoration: InputDecoration(
                        labelText: 'Modelo',
                        errorStyle: TextStyle(fontSize: 14),
                      ),
                      // Ir para o próximo campo
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Digite o modelo';
                        }
                        return null; //return null caso sem erros: input correto
                      },
                      onSaved: (value) {
                        // Recriar o device por que os atributos são finais
                        // Poderia criar uma classe separada só para os produtos que não seja final
                        _editedDevice = Device(
                          id: _editedDevice.id,
                          model: value,
                          description: _editedDevice.description,
                          requested_power_state:
                              _editedDevice.requested_power_state,
                        );
                      },
                      //o que o botão de confirmar do teclado touch irá fazer
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
                        _editedDevice = Device(
                          id: _editedDevice.id,
                          model: _editedDevice.model,
                          description: value,
                          requested_power_state:
                              _editedDevice.requested_power_state,
                        );
                      },
                      //o
                      //o que o botão de confirmar do teclado touch irá fazer
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
