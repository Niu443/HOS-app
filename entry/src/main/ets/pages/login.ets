 import {login_submit,login_type} from '../api/api'
 import { router } from '@kit.ArkUI'
 import preferences  from "../utils/preferences"

 @Entry
@Component

struct login {
  @State @Watch("changeData") formData:login_type={
    userName:"",
     passWord:""
  }
  changeData(){
    this.ruleTip=false
  }
  @State ruleTip:boolean=false

 // login_submit({
 //   userName:"13689587452",
 //   passWord:"123456"
 // })



  build() {
          Column(){
            Text("用户登录").width("100%").fontWeight(FontWeight.Bold).textAlign(TextAlign.Center)
            Row(){
              Text("用户名").width("20%")
              TextInput({placeholder:"账号",text:this.formData.userName}).onChange(value=>{
                this.formData.userName=value
              }).width("70%").borderRadius(0).backgroundColor(Color.White)
            }.margin({top:30})
            Row(){
              Text("密码").width("20%")
              TextInput({placeholder:"密码",text:this.formData.passWord}).onChange(value=>{
                this.formData.passWord=value
              }).width("70%").borderRadius(0).backgroundColor(Color.White)
            }
           if (this.ruleTip){
                Text("写密码账号").fontColor(Color.Red)
           }
            Button("提交").width("80%").margin({top:30})
              .onClick(()=>{
                if (!this.formData.userName||!this.formData.passWord) {
                   this.ruleTip=true
                }
                login_submit(this.formData).then(async (data)=>{
               await   preferences.set("token",data.token)
                  await   preferences.set("userInfo",JSON.stringify(data.userInfo))
                  router.pushUrl({
                    url:"pages/Index"
                  })
                })

              }).alignSelf(ItemAlign.Center)
          }.alignItems(HorizontalAlign.Start).padding(20)
  }
}