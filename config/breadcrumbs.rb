crumb :mypage do
  link "マイページ", mypage_path
end

crumb :new_mypage_group do
  link "グループ作成", new_mypage_group_path
  parent :mypage
end

crumb :mypage_group do |group|
  link group.name, mypage_group_path(group)
  parent :mypage
end

crumb :mypage_group_group_members do |group|
  link "メンバー管理", mypage_group_group_members_path
  parent :mypage_group, group
end

crumb :edit_mypage_group do |group|
  link "編集", edit_mypage_group_path(group)
  parent :mypage_group, group
end

crumb :confirm_destroy_mypage_group do |group|
  link "削除", confirm_destroy_mypage_group_path(group)
  parent :mypage_group, group
end

crumb :new_mypage_group_album do |group|
  link "アルバム作成", new_mypage_group_album_path
  parent :mypage_group, group
end

crumb :edit_mypage_group_album do |album|
  link "編集", mypage_group_album_path(group_id: album.group.id, id: album.id)
  parent :mypage_group_album, album
end

crumb :mypage_group_album do |album|
  link album.name, mypage_group_album_path(group_id: album.group.id, id: album.id)
  parent :mypage_group, album.group
end

crumb :confirm_destroy_mypage_group_album do |album|
  link "削除", confirm_destroy_mypage_group_album_path(group_id: album.group.id, id: album.id)
  parent :mypage_group_album, album
end

crumb :new_mypage_group_album_media_item do |album|
  link "動画・写真の追加", new_mypage_group_album_media_item_path(group_id: album.group.id, album_id: album.id)
  parent :mypage_group_album, album
end
