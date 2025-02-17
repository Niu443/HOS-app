import { preferences } from '@kit.ArkData';

const  name ="userData"
class preferencesUtils{
  async get (key:string,value:preferences.ValueType){
    try {

      const  context:Context=getContext(this)
      const preferences_obj =     await preferences.getPreferences(context,name)
      const result=    await    preferences_obj.get(key,value)
      console.log("userDATA",`获取${key}成功`)
      return result
    } catch (e){
      console.log("userDATA",`获取${key}失败`)
      return value
    }

  }


  async set (key:string,value:preferences.ValueType){
    try {

      const  context:Context=getContext(this)
      const preferences_obj =     await preferences.getPreferences(context,name)
     await  preferences_obj.put(key,value)
      await  preferences_obj.flush()
      console.log("userDATA",`存储${key}成功`)

    } catch (e){
      console.log("userDATA",`存储${key}失败`)

    }

  }

  async declare  (key:string){
    try {

      const  context:Context=getContext(this)
      const preferences_obj =     await preferences.getPreferences(context,name)
      await  preferences_obj.delete(key)
      await  preferences_obj.flush()
      console.log("userDATA",`s${key}成功`)

    } catch (e){
      console.log("userDATA",`s${key}失败`)

    }

  }
}

export  default new preferencesUtils()