with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded.Hash;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

procedure Solution is
  F : File_Type;
  line: unbounded_string;

   package String_Vectors is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => unbounded_string);
   curr_dir: String_Vectors.Vector;

  package Integer_Hashed_Maps is new
    Ada.Containers.Indefinite_Hashed_Maps
      (Key_Type        => unbounded_string,
       Element_Type    => Integer,
       Hash            => Ada.Strings.Unbounded.Hash,
       Equivalent_Keys => "=");
   dir_file_sizes: Integer_Hashed_Maps.Map;

   function always_false(left: in String_Vectors.Vector; right: in String_Vectors.Vector) return Boolean is
   begin
     return false;
   end;

  package String_Hashed_Maps is new
    Ada.Containers.Indefinite_Hashed_Maps
      (Key_Type        => unbounded_string,
       Element_Type    => String_Vectors.Vector,
       Hash            => Ada.Strings.Unbounded.Hash,
       Equivalent_Keys => "=",
       "=" => always_false);
   dir_dirs: String_Hashed_Maps.Map;

   function GetCWD(curr_dir: String_Vectors.Vector) return unbounded_string is
     dir: unbounded_string;
   begin
     if curr_dir.Is_Empty then
       Append(dir, "/");
     end if;

     for C in curr_dir.Iterate loop
       Append(dir, "/");
       Append(dir, curr_dir(C));
     end loop;
     return dir;
   end GetCWD;

   procedure Process_cd is
     cd_prefix: String := "$ cd ";
   begin
    if length(line) >= cd_prefix'length then
      if unbounded_slice(line, 1, cd_prefix'length) = cd_prefix then
        declare
          argument: unbounded_string :=
            unbounded_slice(line, cd_prefix'length + 1, length(line));
        begin
          if argument = ".." then
            curr_dir.Delete(curr_dir.Last_Index);
          else
            if argument = "/" then
              String_Vectors.Clear(curr_dir);
            else
              curr_dir.Append(argument);
            end if;
          end if;
        end;
      end if;
    end if;
   end Process_cd;

  procedure Process_ls is
    ls_prefix: String := "$ ls";
    dir_prefix: String := "dir";
    got_next_cmd: Boolean := false;
  begin
    if line = ls_prefix then
      declare
        cwd: unbounded_string := GetCWD(curr_dir);
      begin
        if not dir_file_sizes.contains(cwd) then
          dir_file_sizes.Include(cwd, 0);
        end if;

        if not dir_dirs.contains(cwd) then
          dir_dirs.Include(cwd, String_Vectors.Empty_Vector);
        end if;

        loop
          exit when end_of_file(F) or got_next_cmd;
          get_line(F, line);
          if unbounded_slice(line, 1, 1) = "$" then
            got_next_cmd := true;
          else
            declare
              split_idx: Natural := Index(line, " ");
              first: unbounded_string := unbounded_slice(line, 1, split_idx - 1);
              last: unbounded_string := unbounded_slice(line, split_idx + 1, length(line));
            begin
              if first = dir_prefix then
                curr_dir.Append(last);
                dir_dirs(cwd).Append(GetCWD(curr_dir));
                curr_dir.Delete(curr_dir.Last_Index);
              else
                dir_file_sizes(cwd) :=
                  dir_file_sizes(cwd) + Integer'Value(To_String(first));
              end if;
            end;
          end if;
        end loop;
      end;

      if got_next_cmd then
        Process_cd;
      end if;
    end if;
  end Process_ls;

  function Resolve_size(name: in unbounded_string;
                        dir_file_sizes: in Integer_Hashed_Maps.Map;
                        dir_dir: in String_Hashed_Maps.Map) return Integer is
    size: Integer := 0;
    subdirs: String_Vectors.Vector := dir_dirs(name);
  begin
    size := dir_file_sizes(name);
    for C in subdirs.Iterate loop
      size := size + Resolve_size(subdirs(C), dir_file_sizes, dir_dirs);
    end loop;
    return size;
  end;
begin
  --  Print "Hello, World!" to the screen
  Open (F, In_File, "input.txt");
  loop
    exit when end_of_file(F);
    get_line(F, line);

    Process_cd;
    Process_ls;
  end loop;
  Close (F);

  declare
    total_space: Integer := 70000000;
    used_space: Integer :=
      Resolve_size(To_unbounded_string("/"), dir_file_sizes, dir_dirs);
    free_space: Integer := (total_space - used_space);

    -- part 1
    total_size: Integer := 0;
    -- part 2
    required_space: Integer := 30000000 - free_space;
    smallest_to_delete: Integer := total_space; -- total_space acts as inifinity
  begin
    for C in dir_file_sizes.Iterate loop
      declare
        curr_size: Integer :=
          Resolve_size(Integer_Hashed_Maps.Key(C), dir_file_sizes, dir_dirs);
      begin
        if curr_size <= 100000 then
          total_size := total_size + curr_size;
        end if;

        if curr_size >= required_space and curr_size < smallest_to_delete then
          smallest_to_delete := curr_size;
        end if;
      end;
    end loop;

    Put_Line(Integer'Image(total_size));
    Put_Line(Integer'Image(smallest_to_delete));
  end;
end Solution;
