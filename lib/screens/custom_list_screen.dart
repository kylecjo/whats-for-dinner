import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/business.dart';
import 'package:whats_for_dinner/models/choose_one_arguments.dart';
import 'package:whats_for_dinner/models/custom_list.dart';
import 'package:whats_for_dinner/models/http_exception.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import 'package:whats_for_dinner/providers/custom_lists.dart';
import 'package:whats_for_dinner/screens/choose_one_screen.dart';
import 'package:whats_for_dinner/widgets/custom_list_dismissible_card.dart';

class CustomListScreen extends StatefulWidget {
  final CustomList customList;
  static const routeName = '/customList';
  final TextEditingController textController = TextEditingController();

  CustomListScreen(this.customList);

  @override
  _CustomListScreenState createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen> {
  void chooseOne(List<Business> businesses, String errorText) {
    try {
      Navigator.pushNamed(
        context,
        ChooseOneScreen.routeName,
        arguments: ChooseOneArguments(businesses),
      );
    } catch (_) {
      final snackBar = SnackBar(
        content: Text(errorText),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _share() async {
    final customListProvider = Provider.of<CustomLists>(context, listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false);
    try {
      await customListProvider.shareList(
          authProvider.uid, widget.customList, widget.textController.text);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Success'),
          content: Text(
              'Share was successful!'),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } on HttpException catch (e) {
      _showErrorDialog(e.message);
    } catch (e) {
      var errorMessage = e.toString();
      if (e.toString().contains('No element')) {
        errorMessage = 'User not found';
      }
      _showErrorDialog(errorMessage);
    }

    widget.textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.customList.name),
        actions: [
          InkWell(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Icon(Icons.casino)),
              onTap: () {
                chooseOne(widget.customList.businesses,
                    'There are no items in this custom list');
              }),
        ],
      ),
      body: Consumer<CustomLists>(
        builder: (ctx, data, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: widget.textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User email',
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Share'),
                    color: Theme.of(context).accentColor,
                    onPressed: _share,
                  ),
                ],
              ),
            ),
            Expanded(
              child: widget.customList.businesses.length > 0
                  ? ListView.builder(
                      itemCount: widget.customList.businesses.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return CustomListDismissibleCard(
                            widget.customList.businesses[index],
                            widget.customList);
                      },
                    )
                  : Text('No restaurants in ${widget.customList.name} yet!'),
            ),
          ],
        ),
      ),
    );
  }
}
