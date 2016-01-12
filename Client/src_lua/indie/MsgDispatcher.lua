MsgDispatcher = {};


--����Ϣ�ַ�ģ�������Lua�е�ԭ���ǣ�c#����LuaTable���ж�̫�鷳��������LuaBehaviour���Խ��յ�����unity�������¼�
MsgDispatcher.mMsgHandlerDict = {};

--ע���߼���Ϣ
--msg: ��Ϣ�����ַ���
--self: �ص�����table
--callback: �ص�������function
function MsgDispatcher.RegLogicMsg(msg, self, callback)
    if msg == nil or msg == "" then
		QPrint("RegLogicMsg Message is nil or Empty");
		return;
	end
	if not callback then
		QPrint("RegLogicMsg callback is nil");
		return;
	end
	if not MsgDispatcher.mMsgHandlerDict[msg] then
		MsgDispatcher.mMsgHandlerDict[msg] = {};
	end
	local handlers = MsgDispatcher.mMsgHandlerDict[msg];
	--��ֹ�ظ�ע��
	for i = 1, #handlers do
		local h = handlers[i];
		if h.self == self and h.callback == callback then
			return;
		end
	end
	local handler = { self = self, callback = callback };
	setmetatable(handler, { __mode = "v" });
	table.insert(handlers, handler);
end

--��ע���߼���Ϣ
--msg: ��Ϣ�����ַ���
--callback: �ص�������function
function MsgDispatcher.UnRegLogicMsg(msg, self, callback)
    if msg == nil or msg == "" then
		QPrint("UnRegLogicMsg Message is nil or Empty");
		return;
	end
	if not callback then
		QPrint("UnRegLogicMsg callback is nil");
		return;
	end	
	local handlers = MsgDispatcher.mMsgHandlerDict[msg];
	--����ɾ����Ҫ�Ӻ���ǰ
	for i = #handlers, 1, -1 do
		local h = handlers[i];
		if h.self == self and h.callback == callback then
			table.remove(handlers, i);
			break;
		end
	end
end

--�����߼���Ϣ
--msg: ��Ϣ�����ַ���
--...: ��Ϣ����
function MsgDispatcher.SendLogicMsg(msg, ...)
    if msg == nil or msg == "" then
		QPrint("UnRegLogicMsg Message is nil or Empty");
		return;
	end
	local handlers = MsgDispatcher.mMsgHandlerDict[msg];
	if handlers == nil then
		return;
	end
	for i = #handlers, 1, -1 do
		if handlers[i].self then
			handlers[i].callback(handlers[i].self, ...);
		else
			--����ע��ı��������ã����ע��ı��Ѿ������٣�����������Ƴ�
			table.remove(handlers, i);
		end
	end
end
