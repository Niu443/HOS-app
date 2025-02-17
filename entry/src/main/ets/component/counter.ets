@Component
export default  struct counter {
  @Prop allSeconds:number
  @State text:string=''

  aboutToAppear(): void {
    this.starCountDown(this.allSeconds)
  }

  updateText(str:string){
    this.text=str
  }
  starCountDown(allSeconds:number){
    let  totalSeconds=Math.floor(allSeconds/1000)

    const fn=()=>{
    const hour =Math.floor(totalSeconds/3600)
    const min =Math.floor((totalSeconds%3600)/60)
    const second =Math.floor(totalSeconds%3600)
    const  str=`${hour.toString().padStart(2,"0")}:${min.toString().padStart(2,"0")}:${second.toString().padStart(2,"0")}`

    this.updateText(str)
    if (totalSeconds<=0) {
      clearInterval(id)
    }
       totalSeconds--
      }
      let id =setInterval(fn,1000)
    fn()
  }

  build() {
     Column(){
       Text(this.text)
         .fontSize(13)
         .fontColor("#ffffa200")
     }
  }
}