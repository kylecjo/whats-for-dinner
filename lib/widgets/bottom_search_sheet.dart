import 'package:flutter/material.dart';

class BottomSearchModal extends StatelessWidget {
  final _textModalSearchNode;
  final _modalSearchTextController;
  final _modalLocationTextController;
  final _textModalLocationNode;
  final _search;

  BottomSearchModal(
    this._textModalSearchNode,
    this._modalSearchTextController,
    this._modalLocationTextController,
    this._textModalLocationNode,
    this._search
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autofocus: true,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
              controller: _modalSearchTextController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                hintText: 'Search',
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).primaryColor),
                fillColor: Colors.white,
                filled: true,
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
              ),
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              focusNode: _textModalSearchNode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onTap: (){
                if(_modalLocationTextController.text == 'Current Location'){
                  _modalLocationTextController.text = '';
                }
              },
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
              controller: _modalLocationTextController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                hintText: 'Location',
                prefixIcon: Icon(Icons.location_on,
                    color: Theme.of(context).primaryColor),
                fillColor: Colors.white,
                filled: true,
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
              ),
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              focusNode: _textModalLocationNode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RaisedButton(
                child: Text('Search',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.white)),
                onPressed: () {
                  _search();
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                },
                color: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
