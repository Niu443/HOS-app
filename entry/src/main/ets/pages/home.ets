import { it } from '@ohos/hypium'
import {getHomeData,return_home_type,slides,nav2s,hospitals} from '../api/api'
import { router } from '@kit.ArkUI'

@Component
export  default  struct home {
  @State homeData:return_home_type|null=null

  aboutToAppear(){
   getHomeData().then(data=>{
     this.homeData=data
   })
  }

  build() {
    Scroll(){
      Column(){
        //1
        Row(){
          Text('中部地区 >')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .width("30%")
            .fontColor("#666666")
            .margin({
              left:10,
              right:5
            })
          Search({placeholder:"找医院"})
            .width("60%")
            .margin({
              left:5,
              right:5
            })
        }.width('100%')
        //2
        Swiper(){
          ForEach(this.homeData?.slides,(item:slides)=>{
            Image(item.pic_image_url)
              .width('100%')
              .padding(5)
              .borderRadius(5)

          })

        }.autoPlay(true)
        .loop(true)
        //3
        Flex(){
          ForEach(this.homeData?.nav2s,(item:nav2s)=>{
            Image(item.pic_image_url)
              .margin({
                left:5,
                right:5
              })

          })
        }
        //4

        ForEach(this.homeData?.hospitals,(item:hospitals)=>{
          Flex(){
            Image(item.avatar_url)
              .width('40%')
              .borderRadius(5)

            Column(){
              Text(item.name)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
              Row(){
                Text(item.rank)
                  .fontWeight(FontWeight.Bold)
                  .margin({
                    right:5
                  })
                  .fontColor('#0ca7ae')
                  .lineHeight(20)
                Text(item.label)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#0ca7ae')
                  .lineHeight(20)
              }

              Text(item.intro)
                .fontSize(14)
                .fontColor('#999999')
                .lineHeight(15)
            }
            .width('60%')
            .alignItems(HorizontalAlign.Start)
            .margin({
              left:5,
              right:5
            })
          }
          .margin(5)
          .padding(10)
          .border({width:1})
          .borderRadius(3)
          .shadow({
            offsetX:0,
            offsetY:1,
            radius:6,
            color:'#66000000'
          })
          .onClick(()=>{
            router.pushUrl({
              url:"pages/createOrder",
              params:{
                id:item.id
              }
            })
          })
        })


      }.alignItems(HorizontalAlign.Start)
    }

  }
}