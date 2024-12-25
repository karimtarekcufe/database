using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBapplication
{
    internal class Controller
    {
        DBManager dbMan;
        public Controller()
        {
            dbMan = new DBManager();
        }


        /**/

        public void TerminateConnection()
        {
            dbMan.CloseConnection();
        }

        public void   selectroles()
        {
            return;
        }
    }
}
