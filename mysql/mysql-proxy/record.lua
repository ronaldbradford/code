--[[

   Copyright (C) 2007 MySQL AB

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; version 2 of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

--]]

---
-- Uses MySQL-Proxy to log your queries
--
-- Written by Ronald Bradford
-- Based on prior examples by Giuseppe Maxia and Jan Knesckhe
--
-- This script will log the queries for each thread so replay is possible
--

require 'socket'

function read_query( packet )
    if string.byte(packet) == proxy.COM_QUERY then
        local query = string.sub(packet, 2)
        query = query:gsub("\n"," "):gsub("\t"," "):gsub("\r"," ")
        local log_file = 'record/' .. proxy.connection.server["thread_id"] .. ".sql"
        local fh = io.open(log_file, "a+")
        now=socket.gettime()
        fh:write( string.format("# %s.%3d\n%s;\n",os.date("%X",now),select(2,math.modf(now))*1000 , query)) 
        fh:flush()
    end
end
