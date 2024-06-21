import prompt from '@ohos.prompt'
import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import { NoteBean } from '../bean/NoteBean'
import RDBUtils from '../utils/RDBUtils'

@Component
@Preview
@Entry
struct WriteNote {
  note: NoteBean = router.getParams()["note"]

  build() {
    Navigation() {
      Column() {
        TextInput({ placeholder: '请输入标题', text: this.note.title??"" })
          .width('100%')
          .height(50)
          .backgroundColor($r('app.color.color_white'))
          .border({ width: 1, radius: 10, color: $r('app.color.color_gray_999') })
          .onChange((s) => {
            this.note.title = s
          })
        TextArea({ placeholder: '请输入内容', text: this.note.content??"" })
          .width('100%')
          .margin({ top: 10 })
          .height(200)
          .backgroundColor($r('app.color.color_white'))
          .border({ width: 1, radius: 10, color: $r('app.color.color_black') })
          .onChange((s) => {
            this.note.content = s
          })
      }.height('100%').padding(16)
    }
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .title(this.BackComponent())
    .hideBackButton(true)
    .menus(this.NavigationManus())
  }

  commit() {
    let context: Context = getContext(this) as Context;
    if (this.note.id) {
      this.note.updateTime = this.getNow()
      RDBUtils.getInstance(context).updateData(this.note, (rows) => {
        this.showToast("编辑成功！")
      }, (msg) => {
        this.showToast(msg)
      })
    } else {
      this.note.createTime = this.getNow()
      RDBUtils.getInstance(context).insertData(this.note, (rowId) => {
        this.showToast("新增成功！")
      }, (msg) => {
        this.showToast(msg)
      })
    }


  }

  @Builder NavigationManus() {
    Row() {
      Image($r('app.media.icon_ok')).width(25).height(25).onClick(() => {
        this.commit()
      })
    }.justifyContent(FlexAlign.End)
  }

  @Builder BackComponent() {
    Row() {
      Image($r('app.media.icon_back')).width(20).height(20)
      Text('返回').margin({ left: 5 }).fontSize(20)
    }.onClick(() => {
      router.back()
    })
  }

  showToast(content) {
    promptAction.showToast({
      message: content,
      duration: 2000,
      bottom: 400
    });
  }

  getNow() {
    let date = new Date(); // 创建一个Date对象
    // 获取年、月、日、时、分、秒
    let year = date.getFullYear();
    let month = date.getMonth() + 1; // 月份是从0开始的，所以要加1
    let day = date.getDate();
    let hours = date.getHours();
    let minutes = date.getMinutes();
    let seconds = date.getSeconds();

    // 拼接成格式化的字符串
    let formattedTime = `${year}-${month < 10 ? '0' + month : month}-${day < 10 ? '0' + day : day} ${hours < 10 ? '0' + hours : hours}:${minutes < 10 ? '0' + minutes : minutes}:${seconds < 10 ? '0' + seconds : seconds}`;
    return formattedTime
  }
}