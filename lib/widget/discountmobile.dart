import 'package:falconpos/theme/textshow.dart';
import 'package:flutter/material.dart';

class DiscountMobile extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController discountstatus;
  final Function onSubmit;
  final double buttonSize;
  final Color buttonColor;
  const DiscountMobile({Key? key, required this.controller, required this.onSubmit, required this.discountstatus, required this.buttonSize, required this.buttonColor}) : super(key: key);

  @override
  State<DiscountMobile> createState() => _DiscountMobileState();
}

class _DiscountMobileState extends State<DiscountMobile> {
  int _disconutstatus = 1;
  @override
  void initState() {
    // TODO: implement initState
    widget.discountstatus.text = '1';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.9,
      height: MediaQuery.of(context).size.height*.8,
      child: Column(
        children: [
          Row(
            children: [

              Expanded(child: RadioListTile(
                title: Text("Amount"),
                value: 1,
                groupValue: _disconutstatus,
                onChanged: (value){
                  setState(() {
                    _disconutstatus = value!;
                    widget.discountstatus.text = _disconutstatus.toString();
                  });
                },
              ),),
              Expanded(child:   RadioListTile(
                title: Text("%"),
                value: 2,
                groupValue: _disconutstatus,
                onChanged: (value){
                  setState(() {
                    _disconutstatus = value!;
                    widget.discountstatus.text = _disconutstatus.toString();
                  });
                },
              ),)

            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.controller.text,style: textBodyLage.copyWith(fontSize: 22,color: Colors.black),)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              NumberButton(
                1,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
              NumberButton(
                2,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
              NumberButton(
                3,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                4,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
              NumberButton(
                5,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
              NumberButton(
                6,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                7,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
              NumberButton(
                8,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
              NumberButton(
                9,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // this button is used to delete the last number
              SizedBox(
                width: widget.buttonSize,
                height: widget.buttonSize,
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white38,
                    elevation: 0,
                    side: BorderSide(color: Colors.black,width: 1,style: BorderStyle.solid),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.buttonSize/2),
                    ),
                  ),
                  onPressed: () {

                    setState(() {
                      widget.controller.text += '.';
                    });

                  },
                  child: Center(
                    child: Text(
                      '.',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
                    ),
                  ),
                ),
              ),

              NumberButton(
                0,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
              IconButton(
                onPressed: () {

                  setState(() {

                    setState(() {

                      widget.controller.text = widget.controller.text
                          .substring(0, widget.controller.text.length - 1);



                    });

                  });
                },
                icon: Icon(
                    Icons.backspace,
                    color: Colors.cyan
                ),
                iconSize: widget.buttonSize,
              ),
              // this button is used to submit the entered value

            ],
          ),
          SizedBox(
            height: 10,
          ),

          Row(
            children: [
              Expanded(child: ElevatedButton(
                onPressed: () => widget.onSubmit(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Discount',style: textBodyLage.copyWith(fontSize: 20),),
                ),
              ))
            ],
          )

        ],

      ),
    );
  }
  Widget NumberButton(int number,double size,Color color,TextEditingController controller) {

    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          side: BorderSide(color: Colors.black,width: 1,style: BorderStyle.solid),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size/2),
          ),
        ),
        onPressed: () {

          setState(() {
            controller.text += number.toString();

          });


        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
