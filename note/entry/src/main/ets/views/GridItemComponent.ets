import { NoteBean } from '../bean/NoteBean'

@Component
export struct GridItemComponent {
  item: NoteBean = null

  build() {
    Column() {
      Text(this.item.title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(this.item.content)
        .fontSize(16)
        .fontColor($r('app.color.color_gray_666'))
        .margin({ top: 5 })
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(this.item.createTime).fontSize(12).fontColor($r('app.color.color_gray_999')).margin({ top: 5 })
    }
    .padding({ left: 10, right: 10, top: 15, bottom: 15 })
    .border({ radius: 10, width: 1, color: $r('app.color.color_line') })
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}