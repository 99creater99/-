import { NoteBean } from '../bean/NoteBean'

@Component
export struct ListItemComponent {
  item: NoteBean = null

  build() {
    Column() {
      Text(this.item.title).fontSize(16).fontWeight(FontWeight.Bold)
      Row() {
        Text(this.item.content).fontSize(16).fontColor($r('app.color.color_gray_666'))
        Text('').layoutWeight(1)
        Text(this.item.createTime).fontSize(16).fontColor($r('app.color.color_gray_999'))
      }.width('100%').margin({ top: 5 })
      // Divider().height(1).backgroundColor($r('app.color.color_line')).margin({top:10})
    }
    .padding({ left: 10, right: 10, top: 15, bottom: 15 })
    .border({ radius: 10, width: 1, color: $r('app.color.color_line') })
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}