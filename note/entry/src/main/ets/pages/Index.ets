import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { ListItemComponent } from '../views/ListItemComponent';
import { GridItemComponent } from '../views/GridItemComponent';
import { NoteBean } from '../bean/NoteBean';
import RDBUtils from '../utils/RDBUtils';




@Entry
@Component
struct Index {
  @State
  list: NoteBean[] = []
  private keyword: string = ""
  private orderBy: string = "create_time"
  private orderByList = ['按创建时间排序', '按编辑时间排序', '按标题排序']
  @State
  private orderByStr: string = this.orderByList[0]
  private select: number = 0


  build() {
    Navigation() {
      Column() {
        Stack() {
          TextInput({ placeholder: '输入搜索内容', text: this.keyword })
            .layoutWeight(2)
            .onChange((s) => {
              this.keyword = s
              this.loadData()
            })
            .height('100%')
            .fontSize(16)
        }
        .backgroundColor($r('app.color.color_light_gray'))
        .width('100%')
        .height(40)
        .borderRadius(10)


        Row() {

          Row() {
            Text(this.orderByStr).fontSize(16)
            Image($r('app.media.icon_down_narrow')).width(30).height(30)
          }.justifyContent(FlexAlign.End).layoutWeight(1).onClick(() => {
            TextPickerDialog.show({
              range: this.orderByList,
              selected: this.select,
              onAccept: (value: TextPickerResult) => {
                this.select = value.index
                if (value.index == 0) {
                  this.orderBy = 'create_time'
                } else if (value.index == 1) {
                  this.orderBy = 'update_time'
                } else {
                  this.orderBy = 'title'
                }
                this.orderByStr = value.value
                this.loadData()
              },
              onCancel: () => {
                console.info("TextPickerDialog:onCancel()")
              },
              onChange: (value: TextPickerResult) => {
                console.info("TextPickerDialog:onChange()" + JSON.stringify(value))
              }
            })
          })
        }
        .padding({ top: 16, bottom: 16 })
        .width('100%')

        //显示已有的篇幅
        List() {
          ForEach(this.list, (item, index) => {
            ListItem() {
              ListItemComponent({ item })
            }.padding({ top: 5 }).swipeAction({ end: this.itemEnd.bind(this, index) }).width('100%').onClick(() => {
              router.pushUrl({
                url: 'pages/WriteNote',
                params: { "note": this.list[index] }
              }, router.RouterMode.Standard, (err) => {
                if (err) {
                  console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                  return;
                }
                console.info('Invoke pushUrl succeeded.');
              })
            })
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ bottom: 10 })

        //最低下的导航栏，包括篇目显示和进入编写界面
        Row() {
          Image($r('app.media.icon_write_note')).width(30).height(30).visibility(Visibility.Hidden)
          Text(this.list.length + '篇备忘录').layoutWeight(1).textAlign(TextAlign.Center)
          Image($r('app.media.icon_write_note')).width(30).height(30).onClick(() => {
            router.pushUrl({
              url: 'pages/WriteNote',
              params: { "note": new NoteBean() }
            })
          })
        }
      }
      .padding(16)
      .width('100%')
      .height('100%')


    }
    .mode(NavigationMode.Stack)
    .title('备忘录')
    .hideBackButton(true)//
  }
//构建组件，数据删除
  @Builder
  LongClickMenu(index) {
    Menu() {
      MenuItem({ startIcon: $r("app.media.icon_delete"), content: "删除" }).onClick(() => {
        this.deleteData(index)
      })
    }
  }
//构建组件，数据删除
  @Builder itemEnd(index) {
    Row() {
      Button({ type: ButtonType.Circle }) {
        Image($r('app.media.icon_delete'))
          .width(40)
          .height(40)
      }.margin({ left: 16 })
      .onClick(() => {
        this.deleteData(index)
      })

    }.alignItems(VerticalAlign.Center).height('100%')
  }
//调用数据加载
  onPageShow() {
    this.loadData()
  }
//删除数据
  deleteData(index) {
    RDBUtils.getInstance(getContext(this)).deleteData(this.list[index].id, (rows) => {
      this.showToast("删除成功")
      this.loadData()
    }, (msg) => {
      this.showToast(msg)
    })
  }
//加载数据
  loadData() {
    let context: Context = getContext(this)
    RDBUtils.getInstance(context).queryData(this.keyword, this.orderBy, (list) => {
      this.list = list
    }, (msg) => {
      this.showToast(msg)
    })
  }
//提示
  showToast(content) {
    promptAction.showToast({
      message: content,
      duration: 2000,
      bottom: 400
    });
  }
}
