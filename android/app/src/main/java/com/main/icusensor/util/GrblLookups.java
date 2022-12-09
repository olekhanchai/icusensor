/*
 *  /**
 *  * Copyright (C) 2017  Grbl Controller Contributors
 *  *
 *  * This program is free software; you can redistribute it and/or modify
 *  * it under the terms of the GNU General Public License as published by
 *  * the Free Software Foundation; either version 2 of the License, or
 *  * (at your option) any later version.
 *  *
 *  * This program is distributed in the hope that it will be useful,
 *  * but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  * GNU General Public License for more details.
 *  *
 *  * You should have received a copy of the GNU General Public License along
 *  * with this program; if not, write to the Free Software Foundation, Inc.,
 *  * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *  * <http://www.gnu.org/licenses/>
 *
 */

package com.main.icusensor.util;

import android.content.Context;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;

public class GrblLookups {

    private final HashMap<String,String[]> lookups = new HashMap<>();

    public GrblLookups(Context context, String prefix) {
        String filename = prefix + ".csv";

        try {
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(context.getAssets().open(filename)))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",");
                    lookups.put(parts[0], parts);
                }
            }
        } catch (IOException ex) {
            System.out.println("Unable to load GRBL resources.");
            ex.printStackTrace();
        }
    }

    public String[] lookup(String idx){
        return lookups.get(idx);
    }

}
