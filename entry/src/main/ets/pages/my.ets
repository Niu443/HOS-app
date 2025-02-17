import {userInfo}from "../api/api"
import { router } from "@kit.ArkUI"
import preferences  from "../utils/preferences"

@Component
export default  struct my {
  changeOrderTab:(index:number,type:string)=>void=()=>{}
  @State userInfo:userInfo|undefined=undefined

async   aboutToAppear() {
    this.userInfo=JSON.parse(await preferences.get("userInfo","")as string)
  }
  server_list:Record<string,string>={
    "app.media.od_10":"待支付",
    "app.media.od_20":"待服务",
    "app.media.od_30":"已完成",
    "app.media.od_40":"已取消",
  }

  ButtonDialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogButton({
      confirm: ()=> {
       this.logout()
      this.ButtonDialogController?.close()
      },

    }),
    offset:{dx:0,dy:200}
  })

 async  logout(){
  await  preferences.declare("token")
   await  preferences.declare("userInfo")
     router.replaceUrl({
       url:"pages/login"
     })
  }
  build() {
    Column(){

      Column(){
        Image(this.userInfo?.avatar).width(100)
        Text(this.userInfo?.name).fontWeight(FontWeight.Bold)
      }.width('100%').backgroundColor(Color.White).height(200).justifyContent(FlexAlign.Center).borderRadius(5)

      Column(){
            Flex({justifyContent:FlexAlign.SpaceBetween}){
              Text('我的订单')
              Text('全部').fontSize(13).fontColor("#999")
            }.border({width:{bottom:1},color:"#ffebedfe"}).padding(5)
        .onClick(()=>{
           this.changeOrderTab(1,"全部")
        })
        Flex({justifyContent:FlexAlign.SpaceAround}){
              
              ForEach(Object.keys(this.server_list),(item:string)=>{
                  Column(){
                    Image($r(item)).width(40)
                    Text(this.server_list[item]).fontSize(13).fontColor('#999')
                  }
                  .onClick(()=>{
                    this.changeOrderTab(1,this.server_list[item])
                  })
              })
        }.margin(5)


      }.width('100%').backgroundColor(Color.White).borderRadius(5).margin({top:10}).padding(10)

      Column(){
        Flex({justifyContent:FlexAlign.SpaceBetween}){
          Text("服务对象管理").lineHeight(20)
          Text('>')
        }.border({width:{bottom:1},color:"#f0f0f0"}).padding(5)
        Flex({justifyContent:FlexAlign.SpaceBetween}){
          Text("分享转发").lineHeight(20)
          Text('>')
        }.padding(5)
      }.width('100%').backgroundColor(Color.White).borderRadius(5).margin({top:10}).padding(10)

      Button("退出登录",{type:ButtonType.Normal}).borderRadius(2).width('90%').backgroundColor(Color.Red).margin({top:10})
        .onClick(()=>{
         this.ButtonDialogController?.open()
        })
    }.backgroundColor('#f0f0f0')
    .height("100%")
    .padding(10)
  }
}

@CustomDialog
export  struct CustomDialogButton {
  controller?: CustomDialogController
  confirm: () => void = () => {
  }


  build() {
    Column() {
      Text('是否确认退出')
        .border({ width: { bottom: 1 } })
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin(10)
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ bottom: 5 })
        .borderColor("#999")

      Flex({justifyContent:FlexAlign.SpaceBetween}){
        Button("确认退出",{type:ButtonType.Normal}).backgroundColor("#ff0839ec").borderRadius(5)
          .onClick(()=>{
            this.confirm()
          })
        Button("取消",{type:ButtonType.Normal}).backgroundColor("#ffee1111").borderRadius(5)
          .onClick(()=>{
            this.controller?.close()
          })
      }.margin(10)

    }
  }
}