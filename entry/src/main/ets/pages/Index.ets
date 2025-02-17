import home from '../pages/home'
import { router } from '@kit.ArkUI'
import orders from "../pages/orders"
import my from "../pages/my"

interface params{
  index:number
}
@Entry
@Component
struct Index {
  TabsController:TabsController =new TabsController()
  @State changeFlag:boolean=true
  @State orderTabIndex:number=0
onPageShow() {
  if (router.getParams()) {
    let index=(router.getParams()as params).index
    this.TabsController.changeIndex(index)

  }
this.changeFlag=true
}

  onPageHide(){
    this.changeFlag=false
  }

  changeOrderTab(index:number,type:string){
    let  list :Array<string>=["全部","待支付","待服务","已完成","已取消"]
    this.TabsController.changeIndex(index)
   this.orderTabIndex= list.indexOf(type)
  }
  build() {
   Tabs({barPosition:BarPosition.End,controller:this.TabsController}){
     TabContent(){
         home()
           .height('100%')
     }.tabBar("首页")
     TabContent(){
          orders({ orderTabIndex:this.orderTabIndex,changeFlag:this.changeFlag}).height('100%')
     }.tabBar("订单")
     TabContent(){
          my({changeOrderTab:(index:number,type:string)=>{this.changeOrderTab(index,type)}}).height('100%')
     }.tabBar("我的")
   }
  }
}