const animation = weex.requireModule('animation')
module.exports = {
	bounceScale(ref){
		return new Promise((resolve)=>{
			animation.transition(ref,{
				styles:{
					transform: 'scale(0.8)',
					opacity:1
				},
		        duration: 100, //ms
		        timingFunction: 'ease-in-out',
		        delay: 0 //ms
			},()=>{
				animation.transition(ref,{
					styles:{
						transform: 'scale(1.2)'
					},
			        duration: 200, //ms
			        timingFunction: 'ease-in-out',
			        delay: 0 //ms
				},()=>{
					animation.transition(ref,{
						styles:{
							transform: 'scale(1)',
							opacity:0
						},
				        duration: 100, //ms
				        timingFunction: 'ease-in-out',
				        delay: 0 //ms
					},()=>{
						resolve()
					});
				});
			});
		})
	}
}
