import schedule from '../component/schedule'
import { getCompanion,return_companion_type,addOrder} from '../api/api'
import {CustomDialogExample,CustomDialogDte,CustomDialogCode} from "../component/dialogs"
import { router } from '@kit.ArkUI'

interface params{
  id:number
}
interface obj_list{
  hospital_name:string,
  time:string
  companion_name:string
  receiveAddress:string
  tel:string,
}
interface form_list_type{
  hospital_name:string,
  starttime:number|undefined
  companion_name:string
  receiveAddress:string
  tel:string
  demand:string
  hospital_id:number|undefined
  companion_id:number|undefined
  time:string
}
@Entry
@Component
struct createOrder {
  @State orderData:return_companion_type | undefined=undefined

  @State rangeList:Array<Array<string|number>>=[]
  @State code:string =''
  @State text_dialog__type:string ="hospital_name"
@State select:number=0
@State @Watch("changeForm")

form_list:form_list_type={
  hospital_name:"请选择医院",
  hospital_id:undefined,
  starttime:undefined,
  time:"请选择就诊时间",
  companion_name:"请选择陪诊师",
  companion_id:undefined,
  receiveAddress:"请填写就诊人地址",
  tel:"请填写您的联系方式",
  demand:"请简单描述你要就诊的科室"
}

  TextDialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({

      confirm: (data:Array<string|number>)=> { this.textConfirmDate(data) },
      type_title:this.text_dialog__type,
      rangeList:this.rangeList,
        select: this.select

    }),
    offset:{dx:0,dy:200}
  })

  DateDialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogDte({

      confirm: (time:Date)=> { this.dateConfirmDate(time) },


    }),
    offset:{dx:0,dy:200}
  })
  codeDialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogCode({
      confirm: ()=> {
       router.back({
         url:"pages/Index",
         params:{index:1}
       })
        this.codeDialogController?.close()
      },
      code:this.code
    }),
    offset:{dx:0,dy:200}
  })

@State ruleTip:boolean=false

  textConfirmDate(data:Array<string|number>){
    if (this.text_dialog__type==='hospital_name') {
      this.form_list.hospital_name=data[0] as string
      this.form_list.hospital_id=data[1] as number
      this.TextDialogController?.close()
    }else {
      this.form_list.companion_name=data[0] as string
      this.form_list.companion_id=data[1] as number
      this.TextDialogController?.close()
    }
  }

  changeForm(){
    this.ruleTip=false
  }
 formatDate(time:Date){
    const year=time.getFullYear().toString()
   const month=(time.getMonth()+1).toString().padStart(2,"0")
   const  date=time.getDate().toString()
   return `${year}-${month}-${date}`
 }

  dateConfirmDate(time:Date){
    this.form_list.time=this.formatDate(time)
    this.form_list.starttime=time.getTime()
    this.DateDialogController?.close()
  }

list:obj_list={
  hospital_name:"就诊医院",
  time:"就诊时间",
  companion_name:"陪诊师",
  receiveAddress:"接送地址",
  tel:"联系电话",
}

submit(){
  let itemArr=["hospital_id","companion_id","starttime","demand","hospital_name","receiveAddress","tel"]
  for (  const element of itemArr) {
    if (!Reflect.get(this.form_list,element)) {
      this.ruleTip=true
      return
    }
  }
  addOrder({
    hospital_name:this.form_list.hospital_name,
    starttime:this.form_list.starttime as number,
    receiveAddress:this.form_list.receiveAddress,
    tel:this.form_list.tel,
    demand:this.form_list.demand,
    hospital_id:this.form_list.hospital_id as number,
    companion_id:this.form_list.companion_id as number,
  }).then(data=>{
    this.code=data.wx_code
    this.codeDialogController?.open()
  })
  }


  onPageShow(){
    getCompanion().then(data =>{
      this.orderData=data
      let id =(router.getParams() as params).id
      if (id) {
        let item =this.orderData.hospitals.find(item=>{
          return item.id===id
        })
        this.form_list.hospital_name=item?.name||""
        this.form_list.hospital_id=id
      }
    })
  }
openDialog(name:string) {
  if (name === "hospital_name") {
    this.text_dialog__type = "hospital_name"
    this.rangeList = this.orderData?.hospitals.map((item,index) => {
      if (item.id===this.form_list.hospital_id) {
        this.select=index
      }
      return [item.name, item.id]
    }) || []
    this.TextDialogController?.open()

  } else if (name === "companion_name") {
    this.text_dialog__type = "companion_name"
    this.rangeList = this.orderData?.companion.map((item,index) => {
      if (item.id===this.form_list.companion_id) {
        this.select=index
      }
      return [item.name, item.id]
    }) || []
    this.TextDialogController?.open()
  }else  if (name==="time"){
    this.DateDialogController?.open()
  }
}


  build() {
  Column(){
    schedule({typeIndex:0})
    Flex({justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}){
      Row(){
        Image(this.orderData?.service.serviceImg)
          .width(25)
          .margin({left:5})

        Text(this.orderData?.service.serviceName)
          .fontSize(13)
      }
      Text('服务内容')
        .fontColor("#969799")
        .fontSize(13)
    }
    .backgroundColor(Color.White)
    .margin(5)
    .padding(15)
    
    ForEach(Object.keys(this.list),(item:string)=>{
    Flex({justifyContent:FlexAlign.SpaceBetween}){
      Text(Reflect.get(this.list,item) as string).fontSize(13)
      if (item==="receiveAddress" ||item=== "tel") {
        TextInput({text:Reflect.get(this.form_list,item)})
          .textAlign(TextAlign.End)
          .borderRadius(0)
          .padding(0)
          .fontColor("#969799")
          .backgroundColor(Color.White)
          .fontSize(13)
          .width('60%')
          .onChange( value =>{
            Reflect.set(this.form_list,item,value)
          })
      }else {
        Text(Reflect.get(this.form_list,item) as string+" >").fontSize(13).fontColor("#969799")
          .onClick(()=>{
           this.openDialog(item)
          })
      }
      

    }
    .backgroundColor(Color.White)
      .padding(15)
      .border({width:{bottom:1},color:"#f0f0f0"})
      .margin({
        left:5,
        right:5
      })
    })

    Text("服务需求")
      .fontSize(15)
      .margin(5)
      .fontColor("#968799")
    TextArea({text:this.form_list.demand})
      .backgroundColor(Color.White)
      .borderRadius(0)
      .margin(5)
      .padding(15)
      .fontSize(13)
      .fontColor("#969799")
      .height(100)
      .onChange(value=>{
        this.form_list.demand=value
      })

    if (this.ruleTip){
      Text("请确认医院，就诊时间等").fontSize(15).fontColor(Color.Red).margin(5)
    }
    Button("提交订单",{type:ButtonType.Normal})
      .borderRadius(5)
      .width('100%')
      .margin({
        top:10
      })
      .onClick(()=>{
             this.submit()
      })

  }.backgroundColor('#f0f0f0')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}

