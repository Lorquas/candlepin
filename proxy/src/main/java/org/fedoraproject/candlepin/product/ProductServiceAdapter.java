/**
 * Copyright (c) 2009 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public License,
 * version 2 (GPLv2). There is NO WARRANTY for this software, express or
 * implied, including the implied warranties of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
 * along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 *
 * Red Hat trademarks are not licensed under GPLv2. No permission is
 * granted to use or replicate Red Hat trademarks that are incorporated
 * in this software or its documentation.
 */
package org.fedoraproject.candlepin.product;

import java.util.List;

import org.fedoraproject.candlepin.model.Product;

/**
 * Product data may originate from a separate service outside Candlepin in some
 * configurations. This interface defines the operations Candlepin requires
 * related to Product data, different implementations can handle whether or not
 * this info comes from Candlepin's DB or from a separate service.
 */
public interface ProductServiceAdapter {

    /**
     * Query a specific product by its ID
     * 
     * @param owner
     * @param subscriptionId
     * @return
     */
    public Product getProduct(String oid);

    /**
     * List all Products
     * 
     * @param owner
     *            Owner.
     * @param productId
     *            Product OID or SKU. (not clear yet)
     * @return
     */
    public List<Product> getProducts();

}
