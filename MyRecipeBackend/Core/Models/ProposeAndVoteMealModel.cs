using System;
using System.Collections.Generic;
using System.Text;
using Core.Entities;

namespace Core.Model
{
    public class ProposeAndVoteMealModel
    {
        public ProposeAndVoteMealModel(Meal meal)
        {
            Meal = meal;
        }

        public Meal Meal { get; set; }
    }
}
