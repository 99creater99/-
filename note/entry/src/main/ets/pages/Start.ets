import router from '@ohos.router';

import dataPreferences from '@ohos.data.preferences';


const PREFERENCES_NAME = 'myPreferences'; // 首选项名字
const KEY_APP_FONT_SIZE = 'app';  // 首选项Key字段


@Entry
@Component
struct PatternLockTest {
  private passwords: Number[] = [0, 1, 2, 3]
  @State message: string = '笔记本验证登录'
  private patternLockController: PatternLockController = new PatternLockController()
  private isresting: boolean = false;
  private canrest: boolean = false;

  build() {
    Column({ space: 30 }) {
      Text($r('app.string.note'))
        .fontSize(80)

      Text(this.message)
        .textAlign(TextAlign.Center)
        .fontSize(20)
      PatternLock(this.patternLockController)
        .sideLength(300) // 设置宽高
        .circleRadius(10) // 设置圆点半径
        .regularColor(Color.Black) // 设置圆点颜色
        .pathStrokeWidth(10) // 设置连线粗细
        .backgroundColor(Color.White) // 设置背景色
        .autoReset(true) // 支持用户在完成输入后再次触屏重置组件状态
        .onPatternComplete((input: Array<number>) => {


          if (input == null || input == undefined || input.length < 4) {
            this.message = "密码长度至少为4位数";
            return;
          }

          if (this.isresting) {
            if (this.passwords.toString() == input.toString()) {
              this.message = '密码验证成功\n请设置密码'
              this.isresting = false;
              this.canrest = true;
              return;
            }
            else {
              this.message = '密码验证失败\n请重新验证'
              return;
            }
          }

          if (this.canrest) {
            this.passwords = input;
            this.canrest = false;
            this.message = "密码设置成功\n可重新验证"
            return;
          }

          if (this.passwords.length > 0) {
            if (this.passwords.toString() == input.toString()) {
              this.message = "登录成功"
              router.push({ // 使用push入栈一个新页面
                url: "pages/Index" // 通过url指定新打开的页面
              })
            }
            else {
              this.message = '密码输入错误'

            }

          }
        })


      Button('重置密码')
        .onClick(() => {
          this.message = '请验证手势密码';
          this.isresting = true;
          this.patternLockController.reset();
        })
    }
    .width('100%')
    .height('100%')
    .padding(80)
  }


  //设置数据
  setSomeThing(key: string, val: string) {
    dataPreferences.getPreferences(getContext(this), PREFERENCES_NAME, (err, preference) => {
      if (err) {
        console.log('get preference error' + err)
        return
      }
      preference.put(key, val, (err) => {
        if (err) {
          console.log('put value error')
          return
        }
        preference.flush((err) => {
          if (err) {
            console.log('flush value error')
            return
          }
          console.log('flush value success')
        })
      })
    })
  }
}