@CustomDialog
export  struct CustomDialogExample {
  controller?: CustomDialogController
  select:number=0
  range:string[]= [ ]
  rangeList:Array<Array<string|number>> =[]
  confirm: (data:Array<string|number>) => void = () => {
  }
  @State selectData:Array<string|number>=[]
  type_title:string='hospital_name'
  gettitle(){
    return this.type_title==="hospital_name"?"请选择医院":"请选择陪诊师"
  }
  aboutToAppear() {
    this.range=  this.rangeList.map(item=>{
      return item[0] as  string
    })

    this.selectData =this.rangeList[this.select]
  }


  build() {
    Column() {
      Text(this.gettitle())
        .border({width:{bottom:1}})
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin(10)
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({bottom:5})
        .borderColor("#999")

      Flex({justifyContent:FlexAlign.SpaceBetween}){
        Button('确认选择',{type:ButtonType.Normal})
          .onClick(()=>{
            this.confirm(this.selectData)
          })
          .borderRadius(5)

        Button('取消',{type:ButtonType.Normal})
          .onClick(()=>{
            this.controller?.close()
          })
          .borderRadius(5)
          .backgroundColor("#ffee1111")
      }.padding(10)

      TextPicker({range:this.range,selected:this.select})
        .onChange((value:string|string[],index:number|number[])=>{
          this.selectData =    this.rangeList[index as  number]
        }).canLoop(this.range.length>3?true:false)
        .width('60%')
      if (this.range.length===0){
        Text("暂无数据")
      }
    }
  }
}
@CustomDialog
export  struct CustomDialogDte {
  controller?: CustomDialogController

  confirm: (time:Date) => void = () => {
  }

timer:Date =new Date(new Date().setDate(new Date().getDate()+1))
@State selectTime:Date = this.timer

  build() {
    Column() {
      Text('请选择就诊时间')
        .border({width:{bottom:1}})
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin(10)
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({bottom:5})
        .borderColor("#999")

      Flex({justifyContent:FlexAlign.SpaceBetween}){
        Button('确认选择',{type:ButtonType.Normal})
          .onClick(()=>{
            this.confirm( this.selectTime)
          })
          .borderRadius(5)

        Button('取消',{type:ButtonType.Normal})
          .onClick(()=>{
            this.controller?.close()
          })
          .borderRadius(5)
          .backgroundColor("#ffee1111")
      }.padding(10)

      DatePicker({

    start:this.timer,
        selected:this.timer
      }).onDateChange((value)=>{
            this.selectTime=value
      })
    }
  }
}
@CustomDialog
export  struct CustomDialogCode {
  controller?: CustomDialogController
  confirm: () => void = () => {
  }

  code:string=''


  build() {
    Column() {
      Text('请使用微信扫码')
        .border({ width: { bottom: 1 } })
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin(10)
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ bottom: 5 })
        .borderColor("#999")

    QRCode(this.code).width(140).height(140)
      Text("X").border({width:1}).borderRadius("50%")
        .width(20)
        .height(20)
        .margin(20)
        .textAlign(TextAlign.Center)

        .onClick(()=>{
          this.confirm()
        })
    }
  }
}