//support placehoder in IE
$(document).ready(function(){
	var inputs = document.getElementsByTagName('input');
	var isSupportPH ='placeholder'in document.createElement('input');
	
	phMimicFunc = function(input){
		var text = input.getAttribute('placeholder');

		if(input.defaultValue == ''){
			input.value = text;
		}

		input.onfocus = function(){
			if(input.value === text){
				this.value = '';
			}
		}
		input.onblur = function(){
			if(input.value === ''){
				this.value = text;
			}
		}
	};
	
	if(!isSupportPH){
		for(var i = 0, len = inputs.length; i < len; i++){
			var input = inputs[i];
			if(input.type==='text' && input.getAttribute('placeholder')) {
				phMimicFunc(input);
			}
		}
	}
});
