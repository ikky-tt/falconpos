
import 'package:dropdown_search/dropdown_search.dart';

import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../api/apiservice.dart';
import '../function/function.dart';
import '../theme/textshow.dart';

class EditBranch extends StatefulWidget {

  final TextEditingController controller2;
  final Function  onSubmit;
  late TextEditingController branchid;
  late TextEditingController brancname;
  late  TextEditingController wh;
   EditBranch({Key? key, required this.controller2, required this.onSubmit,required this.branchid,required this.brancname, required this.wh}) : super(key: key);

  @override
  State<EditBranch> createState() => _EditBranchState();
}

class _EditBranchState extends State<EditBranch> {

  List<SalechanelModel> _salechanel = [];
  List<SelectBranchModel> _selectbranch = [];

  Future<List<SalechanelModel>> getData() async {
    var response = await ApiSerivces().GetSalechanel();

    final data = response.data;
    // print(data);
    if (data != null) {
      return SalechanelModel.fromJsonList(data);
    }

    return [];
  }

  Future<List<SelectBranchModel>> getBranch() async {
    var response = await ApiSerivces().GetBranch();

    final data = response.data;
    // print(data);
    if (data != null) {
      return SelectBranchModel.fromJsonList(data);
    }

    return [];
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.controller2.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

  }
  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(int.parse(DateFormat('yyyy').format(DateTime.now().toLocal()))),
      lastDate: DateTime(int.parse(DateFormat('yyyy').format(DateTime.now().toLocal()))+1),
    );

    if (date != null) {
      setState(() {
        widget.controller2.text = DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }
  String valueChanged2 ='';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        DropdownSearch<SelectBranchModel>(
          asyncItems: (String? filter) => getBranch(),
          popupProps: PopupPropsMultiSelection.modalBottomSheet(
            showSelectedItems: true,
            showSearchBox:false,
            itemBuilder: (BuildContext context, SelectBranchModel item, bool isSelected) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: !isSelected
                    ? null
                    : BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: ListTile(
                  selected: isSelected,
                  title: Text(item.name,style: textBodyLage.copyWith(color: Colors.black),),
                ),
              );
            },

          ),
          compareFn: (item, sItem) => item.id == sItem.id,
          onChanged: (e){
            print(e!.wh);
            setState(() {
              widget.branchid.text = e!.id.toString();
              widget.brancname.text = e.name.toString();
              widget.wh.text = e.wh.toString();
            });
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: textBodyLage.copyWith(fontSize: 14,color: Colors.black),
            dropdownSearchDecoration: InputDecoration(
              enabledBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide:  BorderSide(color: HexColor('3ea3d4'), width: 1.0),
              ),
              labelStyle: textBody.copyWith(fontSize: 14,color: HexColor('3ea3d4')),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(width: 1, color: HexColor('3ea3d4'),),
              ),
              labelText: 'Branch',
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(LineIcons.times,size: 16,color: Colors.white,),
                  Text(' Cancel',style: textBodyMedium.copyWith(color: Colors.white),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
              ),
            ),
            ElevatedButton(
                onPressed: ()=>widget.onSubmit(),
                child: Row(
                  children: [
                    Icon(LineIcons.save,size: 16,color: Colors.white,),
                    Text(' Save',style: textBodyMedium.copyWith(color: Colors.white),),
                  ],
                )),
          ],
        )
      ],
    );
  }
}

class  SalechanelModel {
  late final int id;
  late final String name;

  SalechanelModel({required this.id, required this.name, });

  factory SalechanelModel.fromJson(Map<String, dynamic> json) {

    return SalechanelModel(
      id: json["id"],
      name: json["name"],
    );
  }

  static List<SalechanelModel> fromJsonList(List list) {
    return list.map((item) => SalechanelModel.fromJson(item)).toList();
  }

  String toString() => name;

  @override
  operator ==(o) => o is SalechanelModel && o.id == id;



}

class  SelectBranchModel {
  final int id;
  final String name;
  final String wh;

  SelectBranchModel({required this.id, required this.name, required this.wh });

  factory SelectBranchModel.fromJson(Map<String, dynamic> json) {
    return SelectBranchModel(
        id: json["id"],
        name: json["branch_name"],
        wh: json['wh'].toString()
    );
  }

  static List<SelectBranchModel> fromJsonList(List list) {
    return list.map((item) => SelectBranchModel.fromJson(item)).toList();
  }

  String toString() => name;

  @override
  operator ==(o) => o is SelectBranchModel && o.id == id;


}
