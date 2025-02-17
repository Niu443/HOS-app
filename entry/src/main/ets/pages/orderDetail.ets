import { router } from '@kit.ArkUI'
import {getDetail,return_detail_type} from '../api/api'
import schedule from "../component/schedule"
import counter from  '../component/counter'
import {CustomDialogCode} from '../component/dialogs'
interface params {
  oid:string
}


@Entry
@Component


struct orderDetail {
  @State order_data:return_detail_type|undefined =undefined
  @State allSeconds:number=0
  @State code:string=""
  appointment_from:Record<string,string>={
    "service_name":"预约服务",
    "hospital_name":"就诊医院",
    "starttime":"期望就诊时间",
    "client.name":"就诊人",
    "client.mobile":"就诊人电话",
    "receiveAddress":"接送地址",
    "demand":"其他需求",
  }
  order_from:Record<string,string>={
    "client.mobile":"联系电话",
    "order_start_time":"下单时间",
    "price":"应付金额",
    "out_trade_no":"订单编号",
    "other":"联系客服",
  }
  codeDialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogCode({
      confirm: ()=> {
             this.getDetailDate((router.getParams()as params).oid)
        this.codeDialogController?.close()
      },
      code:this.code
    }),
    offset:{dx:0,dy:200}
  })

  onPageShow() {
    let oid=""
    if ((router.getParams()as params).oid) {
      oid=(router.getParams()as params).oid
      console.log("444",oid)
    }
    // console.log("888",(router.getParams()as params).oid)
      this.getDetailDate(oid)
  }

  getDetailDate(oid:string){
    getDetail({oid}).then(data=>{
      this.order_data=data
      if (data.trade_state==="待支付") {
        this.allSeconds=data.order_start_time +7200000 -Date.now()
        this.code=data.code_url
      }
    })
  }
  formatDate(seconds:number){
    let time =new Date(seconds)
    const year=time.getFullYear().toString()
    const month=(time.getMonth()+1).toString().padStart(2,"0")
    const  date=time.getDate().toString()
    return `${year}-${month}-${date}`
  }
  getValue(str:string):string{

    let  strArr=str.split(".")
    if (str==='other'){
      return '疑问或投诉>'
    }
    if (str==='order_start_time'){
          return this.formatDate(Reflect.get(this.order_data as return_detail_type,str))
    }
    if (strArr.length>1) {
      let result:object|string=this.order_data as return_detail_type

      for (const element of strArr) {
          result=Reflect.get(result as object,element)
      }
      return result as string
    }
    return Reflect.get(this.order_data as return_detail_type,str)

  }
getTypeIndex(){
    let str =this.order_data?.trade_state||"已取消"
  let typeArr:Record<string,number>={"待支付":1,"待服务":2,"已完成":3,"已取消":4}
  return typeArr [str]
}
  build() {
    Scroll(){
      Column(){
        Text("订单详情 ").backgroundColor(Color.White).padding(5)
          .width('100%').textAlign(TextAlign.Center).fontSize(15).lineHeight(20)
        schedule({typeIndex:this.getTypeIndex()})

        //动态内容
        if(this.order_data?.trade_state==="已取消"){
          Column() {
            Text("订单已取消").fontWeight(FontWeight.Bold).fontSize(18).fontColor("#ff7a7a7a").lineHeight(25)
            Text("期待下次为您服务，如需帮助可咨询客服").fontColor("#ff7a7a7a")
          }.alignItems(HorizontalAlign.Start).margin(15)
        }else if(this.order_data?.trade_state==="待服务"){
          Column() {
            Text("正在为您安排服务专员...").fontWeight(FontWeight.Bold).fontSize(18).fontColor("#ff7a7a7a").lineHeight(25)
            Text("请保持手机畅通，稍后将有服务专员与您联系").fontColor("#ff7a7a7a")
          }.alignItems(HorizontalAlign.Start).margin(15)
        }else if(this.order_data?.trade_state==="已完成"){
          Column() {
            Text("服务已完成").fontWeight(FontWeight.Bold).fontSize(18).fontColor("#ff7a7a7a").lineHeight(25)
            Text("感谢您的使用，如有售后问题请联系客服").fontColor("#ff7a7a7a")
          }.alignItems(HorizontalAlign.Start).margin(15)
        }else if(this.order_data?.trade_state==="待支付"){
          Column() {
            Text("订单待支付").fontWeight(FontWeight.Bold).fontSize(18).fontColor("#ff7a7a7a").lineHeight(25)
            Row(){
              Text("请在").fontColor("#ff7a7a7a")
              counter({allSeconds:this.allSeconds})
              Text("内完成支付,超时订单自动取消").fontColor("#ff7a7a7a")
            }
            Column(){
              Button(`立即支付${this.order_data.price}元`, { type: ButtonType.Normal, stateEffect: true })
                .borderRadius(5)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .backgroundColor("#07c160")
                .width("70%")
                .onClick(() => {
                  this.codeDialogController?.open()
                })
            }.width("100%").padding(5)

          }.alignItems(HorizontalAlign.Start).margin(15).width("100%")
        }

        Column(){
          Text('预约信息')
            .fontSize(13)
            .fontWeight(FontWeight.Bold).border({width:{left:3}}).borderColor(Color.Red).padding(3)
          if (this.order_data){
            ForEach(Object.keys(this.appointment_from),(item:string,index)=>{
              Flex({justifyContent:FlexAlign.SpaceBetween}){
                Text(this.appointment_from[item]).fontSize(13)
                Text(this.getValue(item)).fontColor("#999").fontSize(13)
              }.padding(10).border({width:{top:index===0?0:1}}).borderColor('#ffebedf0')
            })
          }
        }.alignItems(HorizontalAlign.Start).backgroundColor(Color.White).padding(10)

        Column(){
          Text('订单信息')
            .fontSize(13)
            .fontWeight(FontWeight.Bold).border({width:{left:3}}).borderColor(Color.Red).padding(3)
          if (this.order_data){
            ForEach(Object.keys(this.order_from),(item:string,index)=>{
              Flex({justifyContent:FlexAlign.SpaceBetween}){
                Text(this.order_from[item]).fontSize(13)
                Text(this.getValue(item)).fontColor("#999").fontSize(13)
              }.padding(10).border({width:{top:index===0?0:1}}).borderColor('#ffebedf0')
            })
          }
        }.alignItems(HorizontalAlign.Start).backgroundColor(Color.White).padding(10).margin({top:10})

      }.backgroundColor("#f0f0f0")


    }

  }
}