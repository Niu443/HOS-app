import {getOrderList,return_order_type}from "../api/api"
import counter from  "../component/counter"
import { router } from "@kit.ArkUI"

@Component
export default  struct orderList {
  @Prop state :number
  @State list:Array<return_order_type>|undefined=undefined
  colorList:Record<string,string>={
    "待支付":"#ffffa200",
    "已取消":"#999999",
    "已完成": "#ff21b121",
    "待服务": "#ff1da6fd"
  }
  aboutToAppear() {
    getOrderList({ state:this.state }).then(data=>{
     this.list=data
      this.list=this.list.map(item=>{
        if (item.trade_state==="待支付") {
          item.order_start_time=  item.order_start_time+7200000 - Date.now()
        }
        return item
      })
    })
  }
  build() {

    Scroll(){
      Column(){
        ForEach(this.list,(item:return_order_type)=>{
          Flex({justifyContent:FlexAlign.SpaceBetween}){
            Row(){
              Image(item.serviceImg).width(50)
              Column(){
                Text(item.service_name).fontWeight(FontWeight.Bold)
                Text(item.hospital_name).fontSize(13).fontColor('#999').lineHeight(20)
                Text(item.starttime).fontSize(13).fontColor('#999')

              }.alignItems(HorizontalAlign.Start).margin({left:15})
            }
            Column(){
              Text(item.trade_state).fontColor(this.colorList[item.trade_state]).fontSize(13)
              if (item.trade_state==="待支付") {
                counter({allSeconds:item.order_start_time})
              }
            }.margin({top:5,right:5})

         
          }.margin(5)
          .backgroundColor(Color.White)
          .borderRadius(2)
          .padding(5)

          .onClick(()=>{
            router.pushUrl({
              url:"pages/orderDetail",
              params:{
                oid:item.out_trade_no
              }
            })
          })
        })


        Text("没有更多了").margin(20)
      }
    }

  }
}