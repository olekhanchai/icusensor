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

public class UiToastEvent {

    private String message;
    private Boolean longToast;
    private Boolean isWarning;

    public UiToastEvent(String message){
        this.message = message;
        this.longToast = false;
        this.isWarning = false;
    }

    public UiToastEvent(String message, Boolean longToast){
        this.message = message;
        this.longToast = longToast;
        this.isWarning = false;
    }

    public UiToastEvent(String message, Boolean longToast, Boolean isWarning){
        this.message = message;
        this.longToast = longToast;
        this.isWarning = isWarning;
    }

    public String getMessage(){ return this.message; }
    public void setMessage(String message){ this.message = message; }

    public Boolean getLongToast(){ return this.longToast; }
    public void setLongToast(Boolean longToast){ this.longToast = longToast; }

    public Boolean getIsWarning(){ return this.isWarning; }
    public void setIsWarning(boolean isWarning){
        this.isWarning = isWarning;
    }

}
