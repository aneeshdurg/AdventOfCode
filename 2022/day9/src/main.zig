const std = @import("std");

const Location = struct {x: i32, y: i32};

fn LogLocation(loc: Location) void {
    std.debug.print("x: {}, y: {}\n", .{loc.x, loc.y});
}

fn printState(h: Location, t: Location, n: i32) void {
    LogLocation(h);
    LogLocation(t);
    var yi = n - 1;
    while (yi >= 0) : (yi -= 1) {
        var xi: i32 = 0;
        while (xi <= n) : (xi += 1) {
            const loc = Location { .x = xi, .y = yi };
            if (loc.x == h.x and loc.y == h.y) {
                std.debug.print("H", .{});
            } else if (loc.x == t.x and loc.y == t.y) {
                std.debug.print("T", .{});
            } else if (loc.x == 0 and loc.y == 0) {
                std.debug.print("S", .{});
            } else {
                std.debug.print(".", .{});
            }
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("\n", .{});
}


fn catchUp(head_loc: Location, tail_loc: *Location) void {
    if (head_loc.x == tail_loc.*.x and head_loc.y == tail_loc.*.y) {
        return;
    }

    const diff = Location {
        .x = head_loc.x - tail_loc.*.x,
        .y = head_loc.y - tail_loc.*.y,
    };

    const absx = std.math.absInt(diff.x) catch unreachable;
    const absy = std.math.absInt(diff.y) catch unreachable;

    if (absx <= 1 and absy <= 1) {
        return;
    }

    // std.debug.print("  dx: {}, dy: {}\n", .{diff.x, diff.y});
    // std.debug.print("    update x: {}, y: {}\n", .{std.math.sign(diff.x), std.math.sign(diff.y)});

    tail_loc.*.x += std.math.sign(diff.x);
    tail_loc.*.y += std.math.sign(diff.y);
    return;
}

pub fn main() !void {
    //  Get an allocator
    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    // Get the path
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath("./input.txt", &path_buffer);

    // Open the file
    const file = try std.fs.openFileAbsolute(path, .{ .mode = std.fs.File.OpenMode.read_only });
    defer file.close();

    const info = try file.stat();
    // Read the contents
    const buffer_size = info.size;
    const file_buffer = try file.readToEndAlloc(allocator, buffer_size);
    defer allocator.free(file_buffer);

    // Split by "\n" and iterate through the resulting slices of "const []u8"
    var iter = std.mem.split(u8, file_buffer, "\n");

    var count: usize = 0;
    var rope = std.ArrayList(Location).init(allocator);
    defer _ = rope.deinit();

    var rope_len: usize = 10;
    var rope_i: usize = 0;
    while (rope_i < rope_len) : (rope_i += 1) {
        try rope.append(Location { .x = 0, .y = 0 });
    }

    var visited = std.AutoHashMap(Location, void).init(allocator);
    defer _ = visited.deinit();

    std.debug.print("Initial state\n", .{});
    // printState(head_loc, tail_loc, 90);

    while (iter.next()) |line| : (count += 1) {
        if (line.len == 0) {
            break;
        }
        // std.log.info("{d:>2}: {s} {d}", .{ count, line, line.len });
        var tokens = std.mem.tokenize(u8, line, " ");
        const dir = tokens.next().?[0];
        const len = try std.fmt.parseInt(i32, tokens.next().?, 10);
        // std.log.info("dir: {c} len: {d}", .{ dir, len });

        var delta = Location { .x = 0, .y = 0 };
        if (dir == 'R') {
            delta.x += 1;
        } else if (dir == 'L') {
            delta.x -= 1;
        } else if (dir == 'U') {
            delta.y += 1;
        } else if (dir == 'D') {
            delta.y -= 1;
        }

        // std.debug.print("{s}\n", .{line});

        var i:i32 = 0;
        while (i < len) : (i+=1) {
            rope.items[0].x += delta.x;
            rope.items[0].y += delta.y;

            try visited.put(rope.items[rope_len - 1], {});
            var curr_rope_idx: usize = 0;
            while (curr_rope_idx < (rope_len - 1)) : (curr_rope_idx += 1) {
                catchUp(rope.items[curr_rope_idx], &rope.items[curr_rope_idx + 1]);
            }
            // LogLocation(head_loc);
            // LogLocation(tail_loc);
            // printState(head_loc, tail_loc, 90);
            // LogLocation(head_loc);
            // LogLocation(tail_loc);
            try visited.put(rope.items[rope_len - 1], {});
        }

        // while (catchUp(head_loc, &tail_loc)) {
        //     LogLocation(head_loc);
        //     LogLocation(tail_loc);
        //     try visited.put(tail_loc, {});
        // }
        // try visited.put(tail_loc, {});
    }

    var max_x: i32 = 0;
    var max_y: i32 = 0;
    var keys = visited.keyIterator();
    while (keys.next()) |key| {
        if (key.x > max_x) {
            max_x = key.x;
        }

        if (key.y > max_y) {
            max_y = key.y;
        }
    }

    var yi: i32 = max_y;
    while (yi >= 0) : (yi -= 1) {
        var xi: i32 = 0;
        while (xi <= (max_x + 1)) : (xi += 1) {
            const loc = Location { .x = xi, .y = yi };
            if (visited.contains(loc)) {
                std.debug.print("#", .{});
            } else {
                std.debug.print(".", .{});
            }
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("origin contained {}\n", .{ visited.contains(Location {.x=0, .y=0}) });

    std.debug.print("Visited {d} locations\n", .{ visited.count() });
}
