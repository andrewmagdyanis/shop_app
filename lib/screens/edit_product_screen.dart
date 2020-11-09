import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:validators/validators.dart';
import 'package:validators/sanitizers.dart';

class EditProductScreen extends StatefulWidget {
  final bool addingBehavior;
  final String oldProductID;

  EditProductScreen({
    this.addingBehavior,
    this.oldProductID,
  });

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _idFocusNode = FocusNode();
  FocusNode _descFocusNode = FocusNode();
  FocusNode _urlFocusNode = FocusNode();
  TextEditingController _urlController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Product _editedProduct = Product(id: null, title: '', description: '', imageUrl: '', price: 0);
  String currentUrl = '';
  bool initDone = false;
  bool isLoading = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _urlController.addListener(() {
      setState(() {
        currentUrl = _urlController.value.text;
      });
      if (!_urlFocusNode.hasFocus) setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!initDone && !widget.addingBehavior) {
      _editedProduct =
          Provider.of<Products>(context, listen: false).getProductById(widget.oldProductID);
      _urlController.text = _editedProduct.imageUrl;
    }
    initDone = true;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descFocusNode.dispose();
    _idFocusNode.dispose();
    _priceFocusNode.dispose();
    _urlFocusNode.dispose();
    _urlController.dispose();

    super.dispose();
  }

  Future<void> saveForm(BuildContext context) async {
    var valid = _formKey.currentState.validate();
    if (valid) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();

      try {
        (widget.addingBehavior)
            ? await Provider.of<Products>(context, listen: false).addItem(_editedProduct)
            : await Provider.of<Products>(context, listen: false)
                .updateItem(_editedProduct.id, _editedProduct);
      } catch (e) {
        print('2nd error catch');
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('error in backend'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'),
                  ),
                ],
              );
            });
      }
    }

    //  scaffoldKey.currentState.showSnackBar(SnackBar(duration: Duration(seconds: 2),
    //   content: Text('Saved'),
    // // ));
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text('Saved'),
    // ));
    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    (!widget.addingBehavior)?
    print('Build: EditProductScreen'):print('Build: AddingProdutScreen');
    return Builder(
      builder: (context) => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: AutoSizeText(widget.addingBehavior?'Adding product page':'Edit product page',
            maxLines: 1,
            style: TextStyle(fontSize: 30),

            overflow: TextOverflow.ellipsis,
            softWrap: true,
            wrapWords: true,
            minFontSize: 0,
            stepGranularity: 0.1,

          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              iconSize: 30,
              onPressed: () {
                saveForm(context);
              },
            )
          ],
        ),
        body: (isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      TextFormField(
                          initialValue: _editedProduct.title,
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: value,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                price: _editedProduct.price);
                          }),
                      TextFormField(
                        initialValue: _editedProduct.price.toString(),
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        focusNode: _priceFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the product price.';
                          }

                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter real price.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value));
                        },
                      ),
                      TextFormField(
                          initialValue: _editedProduct.description,
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                          focusNode: _descFocusNode,
                          maxLines: 3,
                          minLines: 1,
                          textInputAction: TextInputAction.newline,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: value,
                                imageUrl: _editedProduct.imageUrl,
                                price: _editedProduct.price);
                          }),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.yellow[900], width: 2),
                                ),
                                child: _urlController.text.isEmpty ||
                                        !isURL(_urlController.text, allowUnderscore: true)
                                    ? Text('Enter url')
                                    : FittedBox(
                                        child: Image.network(
                                          currentUrl,
                                          repeat: ImageRepeat.repeat,
                                          errorBuilder: (context, Object url, error) {
                                            return Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Text('Enter valid url'),
                                            );
                                          },
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Url',
                                    ),
                                    focusNode: _urlFocusNode,
                                    maxLines: 3,
                                    minLines: 1,
                                    textInputAction: TextInputAction.done,
                                    controller: _urlController,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        currentUrl = value;
                                      });
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter the url';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        _editedProduct = Product(
                                            id: _editedProduct.id,
                                            title: _editedProduct.title,
                                            description: _editedProduct.description,
                                            imageUrl: value,
                                            price: _editedProduct.price);
                                      });
                                    }),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
