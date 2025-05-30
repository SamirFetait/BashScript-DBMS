#!/bin/bash

DataBase_Folder="./MyDatabase"
mkdir -p "$DataBase_Folder"

main_menu() {
  while true
  do
    echo ""
    echo "Main Menu"
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Drop Database"
    echo "5. Exit"
    read -p "Choose an option: " choice

    if [ "$choice" == "1" ]; then
      create_database
    elif [ "$choice" == "2" ]; then
      list_databases
    elif [ "$choice" == "3" ]; then
      connect_to_database
    elif [ "$choice" == "4" ]; then
      drop_database
    elif [ "$choice" == "5" ]; then
      echo "Goodbye!"
      exit
    else
      echo "Invalid option. Please try again."
    fi
  done
}

create_database() {
  read -p "Enter new database name: " db_name
  mkdir "$DataBase_Folder/$db_name" 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "Database '$db_name' created."
  else
    echo "Database already exists."
  fi
}

list_databases() {
  echo "Databases:"
  ls "$DataBase_Folder"
}

drop_database() {
  read -p "Enter database name to delete: " db_name
  rm -r "$DataBase_Folder/$db_name" 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "Database '$db_name' deleted."
  else
    echo "Database not found."
  fi
}

connect_to_database() {
  read -p "Enter database name to connect: " db_name
  if [ -d "$DataBase_Folder/$db_name" ]; then
    cd "$DataBase_Folder/$db_name"
    table_menu
    cd - > /dev/null
  else
    echo "Database not found."
  fi
}

table_menu() {
  while true
  do
    echo ""
    echo "Table Menu"
    echo "1. Create Table"
    echo "2. List Tables"
    echo "3. Drop Table"
    echo "4. Insert Into Table"
    echo "5. Select From Table"
    echo "6. Delete From Table"
    echo "7. Update Table"
    echo "8. Back to Main Menu"
    read -p "Choose an option: " choice

    if [ "$choice" == "1" ]; then
      create_table
    elif [ "$choice" == "2" ]; then
      list_tables
    elif [ "$choice" == "3" ]; then
      drop_table
    elif [ "$choice" == "4" ]; then
      insert_into_table
    elif [ "$choice" == "5" ]; then
      select_from_table
    elif [ "$choice" == "6" ]; then
      delete_from_table
    elif [ "$choice" == "7" ]; then
      update_table
    elif [ "$choice" == "8" ]; then
      break
    else
      echo "Invalid option."
    fi
  done
}

create_table() {
  read -p "Enter table name: " table
  touch "$table.table" "$table.meta"

  read -p "Enter columns like id:int,name:string: " columns
  echo "$columns" | tr ',' '\n' > "$table.meta"

  read -p "Enter primary key column name: " pk
  echo "PK:$pk" >> "$table.meta"
  echo "Table '$table' created."
}

list_tables() {
  echo "Tables:"
  ls *.table 2>/dev/null | sed 's/.table$//'
}

drop_table() {
  read -p "Enter table name to delete: " table
  rm "$table.table" "$table.meta" 2>/dev/null
  echo "Table '$table' deleted if it existed."
}

insert_into_table() {
  read -p "Enter table name: " table
  if [ ! -f "$table.table" ]; then
    echo "Table not found."
    return
  fi

  columns=( $(cut -d: -f1 "$table.meta" | grep -v PK) )
  types=( $(cut -d: -f2 "$table.meta" | grep -v PK) )
  pk=$(grep PK "$table.meta" | cut -d: -f2)
  row=""

  for i in ${!columns[@]}
  do
    read -p "Enter ${columns[$i]} (${types[$i]}): " value

    if [ "${columns[$i]}" == "$pk" ]; then
      if grep -q "^$value:" "$table.table"; then
        echo "Primary key already exists."
        return
      fi
    fi

    row="$row$value:"
  done

  echo "${row::-1}" >> "$table.table"
  echo "Row inserted."
}

select_from_table() {
  read -p "Enter table name: " table
  if [ ! -f "$table.table" ]; then
    echo "Table not found."
    return
  fi

  head=$(cut -d: -f1 "$table.meta" | grep -v PK | tr '\n' '\t')
  echo -e "$head"
  cat "$table.table" | tr ':' '\t'
}

delete_from_table() {
  read -p "Enter table name: " table
  read -p "Enter primary key value to delete: " value
  if [ ! -f "$table.table" ]; then
    echo "Table not found."
    return
  fi

  grep -v "^$value:" "$table.table" > temp && mv temp "$table.table"
  echo "Deleted if existed."
}

main_menu
