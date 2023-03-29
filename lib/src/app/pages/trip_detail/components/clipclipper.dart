import 'package:exxe/src/utils/export/ui_export.dart';

class RPSCustomPainter extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 38, 147, 233)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
     
         
    Path path0 = Path();
    path0.moveTo(size.width*0.3750000,size.height*0.2857143);
    path0.lineTo(size.width*0.5831667,size.height*0.2871429);
    path0.lineTo(size.width*0.5833333,size.height*0.3585714);
    path0.quadraticBezierTo(size.width*0.5720417,size.height*0.3707857,size.width*0.5691667,size.height*0.3862857);
    path0.quadraticBezierTo(size.width*0.5710833,size.height*0.4015000,size.width*0.5835000,size.height*0.4151429);
    path0.lineTo(size.width*0.5833333,size.height*0.6431429);
    path0.lineTo(size.width*0.3751667,size.height*0.6442857);
    path0.lineTo(size.width*0.3748333,size.height*0.4128571);
    path0.quadraticBezierTo(size.width*0.3872917,size.height*0.3992143,size.width*0.3890000,size.height*0.3860000);
    path0.quadraticBezierTo(size.width*0.3869583,size.height*0.3710714,size.width*0.3748333,size.height*0.3580000);
    path0.lineTo(size.width*0.3750000,size.height*0.2857143);
    path0.close();

    canvas.drawPath(path0, paint0);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}
