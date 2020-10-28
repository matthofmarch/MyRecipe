using System;
using System.Collections.Generic;
using System.Text;
using Core.Entities;

namespace Core.Model.Response
{
    public class MealDto
    {
        public MealDto(string initiatorName, Guid mealId, Uri imageUri)
        {
            InitiatorName = initiatorName;
            MealId = mealId;
            ImageUri = imageUri;
        }

        public string InitiatorName { get; set; }
        public Guid MealId { get; set; }
        public Uri ImageUri { get; set; }
    }
}
