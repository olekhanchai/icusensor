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

package com.main.icusensor.events;

import com.main.icusensor.model.Position;

public class GrblProbeEvent {

    private final String probeString;
    private Position probePosition;
    private Boolean isProbeSuccess = false;

    public GrblProbeEvent(String probeString){
        this.probeString = probeString;
        this.parseProbeString();
    }

    private void parseProbeString(){
        String parts[] = probeString.split(":");
        String coordinates[] = parts[0].split(",");

        this.probePosition = new Position(Double.parseDouble(coordinates[0]), Double.parseDouble(coordinates[1]), Double.parseDouble(coordinates[2]));
        this.isProbeSuccess = parts[1].equals("1");
    }

    public Boolean getIsProbeSuccess(){ return this.isProbeSuccess; }

    public Double getProbeCordX(){ return this.probePosition.getCordX(); }

    public Double getProbeCordY(){ return this.probePosition.getCordY(); }

    public Double getProbeCordZ(){ return this.probePosition.getCordZ(); }

    public Position getProbePosition(){ return this.probePosition; }

}
