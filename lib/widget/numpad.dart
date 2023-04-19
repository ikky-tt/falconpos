import 'package:falconpos/theme/textshow.dart';
import 'package:flutter/material.dart';

// KeyPad widget
// This widget is reusable and its buttons are customizable (color, size)
class NumPad extends StatefulWidget {
  final double buttonSize;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final Function delete;
  final Function onSubmit;

  const NumPad({
    Key? key,
    this.buttonSize = 70,
    this.buttonColor = Colors.white38,
    this.iconColor = Colors.amber,
    required this.delete,
    required this.onSubmit,
    required this.controller,
  }) : super(key: key);
  @override
  State<NumPad> createState() => _NumPadState();
}
class _NumPadState extends State<NumPad> {
   String _qtytext = '';
  @override
  void initState() {
    // TODO: implement initState
    _qtytext = widget.controller.text;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2, right: 2,top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Quantity ',style: textBodyLage.copyWith(fontSize: 24,color: Colors.black),),),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: InkWell(
                            child: const Icon(Icons.remove),
                            onTap: () {
                              if(_qtytext != '0') {
                                widget.controller.text = (num.parse(
                                    widget.controller.text) - 1).toString();

                                _qtytext = widget.controller.text;

                                setState(() {

                                });
                              }

                            }
                          )),

                      Expanded(child: Container(
                        alignment: Alignment.center,
                        child: Text(_qtytext,style: textBodyLage.copyWith(fontSize: 24,color: Colors.black),),
                      )),
                      Expanded(
                          child: InkWell(
                            child: const Icon(Icons.add),
                            onTap: () {

                          widget.controller.text = (num.parse(widget.controller.text) +1).toString();

                          _qtytext = widget.controller.text;

                          setState(() {

                          });




                            },
                          ))
                    ],

              )
              )
            ],
          ),
          const SizedBox(height: 40),
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
              IconButton(
                onPressed: () {
                  widget.delete();
                  setState(() {

                    widget.controller.text = widget.controller.text
                        .substring(0, _qtytext.length - 1);

                    _qtytext = widget.controller.text;

                  });
                },
                icon: Icon(
                  Icons.backspace,
                  color: widget.iconColor,
                ),
                iconSize: widget.buttonSize,
              ),
              NumberButton(
               0,
                widget.buttonSize,
                widget.buttonColor,
                widget.controller,
              ),
              // this button is used to submit the entered value
              IconButton(
                onPressed: () => widget.onSubmit(),
                icon: Icon(
                  Icons.done_rounded,
                  color: widget.iconColor,
                ),
                iconSize: widget.buttonSize,
              ),
            ],
          ),
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
            _qtytext = controller.text;
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

// define NumberButton widget
// its shape is round
