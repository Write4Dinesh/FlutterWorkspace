void main(){
//function expression. no function name is allowed
 FutureOr f = (d){
                  print("resumed!!");
	             };
				 
				 executeDelayed(5,f);// execute a task 'f' after 5 secons
}

void executeDelayed(seconds,f)  {
  Duration duration = new Duration(seconds:seconds);
   ;// it is called function expression. the function shouldn't have any name in a function expression.
   var future =  Future.delayed(duration);
             print("last");
 
  future.then(f);
}
