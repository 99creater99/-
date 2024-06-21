import relationalStore from '@ohos.data.relationalStore'
import { NoteBean } from '../bean/NoteBean'

export default class RDBUtils {
  private context: Context = null
  private static instance: RDBUtils

  constructor(context: Context) {
    this.context = context
    this.initRDB();
  }

  static getInstance(context: Context): RDBUtils {
    if (!this.instance) {
      this.instance = new RDBUtils(context)
    }
    return this.instance
  }

  private initRDB() {
    const STORE_CONFIG = {
      name: 'note.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS NOTE (ID INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,' +
    ' content TEXT NOT NULL, create_time TEXT NOT NULL,update_time TEXT)'; // 建表Sql语句

    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`Succeeded in getting RdbStore.`);
      store.executeSql(SQL_CREATE_TABLE).then(() => {
      }); // 创建数据表
    })
  }

  // @ts-ignore
  public insertData(note: NoteBean, successCallback, failCallback) {
    const valueBucket = {
      "title": note.title,
      "content": note.content,
      "create_time": note.createTime,
      "update_time": note.updateTime
    }
    const STORE_CONFIG = {
      name: 'note.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      store.insert("note", valueBucket, (err, rowId) => {
        if (err) {
          console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
          failCallback(err.message)
          return;
        }
        console.info(`Succeeded in inserting data. rowId:${rowId}`);
        successCallback(rowId)
      })
    })
  }

  public updateData(note: NoteBean, successCallback, failCallback) {
    const valueBucket = {
      "title": note.title,
      "content": note.content,
      "create_time": note.createTime,
      "update_time": note.updateTime
    }
    const STORE_CONFIG = {
      name: 'note.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    let predicates = new relationalStore.RdbPredicates('note');
    predicates.equalTo("id", note.id) //声明where条件
    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      //新增数据
      store.update(valueBucket, predicates, (err, rows) => {
        if (err) {
          console.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
          failCallback(err.message)
          return;
        }
        console.info(`Succeeded in updating data. row count:${rows}`);
        successCallback(rows)
      }
      )
    }
    )
  }

  public deleteData(id, successCallback, failCallback) {
    const STORE_CONFIG = {
      name: 'note.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    let predicates = new relationalStore.RdbPredicates('note');
    predicates.equalTo("id", id) //声明where条件
    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      //新增数据
      store.delete(predicates, (err, rows) => {
        if (err) {
          console.error(`Failed to delete  data. Code:${err.code}, message:${err.message}`);
          failCallback(err.message)
          return;
        }
        console.info(`Succeeded in delete  data. row count:${rows}`);
        successCallback(rows)
      }
      )
    }
    )
  }

  public queryData(keyword, orderBy: string, successCallback, failCallback): any {
    const STORE_CONFIG = {
      name: 'note.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    let predicates = new relationalStore.RdbPredicates('note');
    if (orderBy == 'title') {
      predicates.orderByAsc(orderBy)
    } else
      predicates.orderByDesc(orderBy)


    predicates.like("content", `%${keyword}%`).or().like("title", `%${keyword}%`) //模糊查询条件

    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      //新增数据
      store.query(predicates, ["id", "title", "content", "create_time", "update_time"], (err, resultSet) => {
        if (err) {
          failCallback(err.message)
          return
        }

        let count = resultSet.rowCount

        if (count > 0) {
          const list: NoteBean[] = [];
          resultSet.goToFirstRow()
          for (let i = 0; i < count; i++) {
            let data: NoteBean = {
              id: resultSet.getString(resultSet.getColumnIndex('id')),
              title: resultSet.getString(resultSet.getColumnIndex('title')),
              content: resultSet.getString(resultSet.getColumnIndex('content')),
              createTime: resultSet.getString(resultSet.getColumnIndex('create_time')),
              updateTime: resultSet.getString(resultSet.getColumnIndex('update_time')),
            };
            list[i] = data
            resultSet.goToNextRow();
          }
          successCallback(list)
        } else {
          successCallback([])
        }
      }
      )
    }
    )
  }
}